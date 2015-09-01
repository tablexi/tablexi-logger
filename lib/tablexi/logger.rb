require "logger"

require "tablexi/logger/version"
require "tablexi/logger/severities"
require "tablexi/logger/new_relic"
require "tablexi/logger/rollbar"
require "tablexi/logger/standard"
require "tablexi/logger/option_filter/humanize_request"

module Tablexi
  class << self
    attr_writer :logger

    def logger
      @logger ||= default_logger
    end

    def default_logger(base_logger = bare_logger)
      Logger.new.tap do |logger|
        logger.option_filters << Tablexi::Logger::OptionFilter::HumanizeRequest
        Tablexi::Logger::SEVERITIES.each do |severity|
          logger.handlers[severity] << Tablexi::Logger::Standard.new(base_logger, severity: severity)
        end
        trackable_severities = %i(error fatal unknown)
        logger.handle trackable_severities, &Tablexi::Logger::Rollbar if defined?(::Rollbar)
        logger.handle trackable_severities, &Tablexi::Logger::NewRelic if defined?(::NewRelic)
      end
    end

    private def bare_logger
      Rails.logger
    rescue NameError
      ::Logger.new($stdout).tap do |config|
        config.level = ::Logger::DEBUG
      end
    end
  end

  class Logger
    include Severities

    attr_reader :option_filters
    attr_reader :handlers

    def initialize
      @option_filters = []
      @handlers = Hash.new { |h, k| h[k] = [] }
    end

    def handle(severities, &block)
      raise ArgumentError, "Missing block argument" unless block_given?
      raise ArgumentError, "lambda must take 2 arguments: `error, options`" if block.lambda? && block.arity.abs != 2

      Array(severities).each { |severity| handlers[severity] << block }
    end

    SEVERITIES.each do |severity|
      define_method(severity) do |exception_or_message, options = {}|
        log(severity, exception_or_message, Hash(options))
      end
    end

    private

    def log(severity, exception_or_message, options)
      process_option_filters(options)
      handlers[severity].each do |handler|
        handler.call(exception_or_message, options)
      end
      nil
    rescue StandardError => e
      if options.key? :tablexi_logger_error
        raise # recursion prevention
      else
        error(e, tablexi_logger_error: true)
      end
    end

    def process_option_filters(options)
      option_filters.each_with_object(options) { |filter, opts| filter.call(opts) }
    end
  end
end
