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
          logger.handler_mapping[severity] << Tablexi::Logger::Standard.new(base_logger, severity: severity)
        end
        %i(error fatal unknown).each do |severity|
          logger.handler_mapping[severity] << Tablexi::Logger::Rollbar if defined?(::Rollbar)
          logger.handler_mapping[severity] << Tablexi::Logger::NewRelic if defined?(::NewRelic)
        end
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
    attr_reader :handler_mapping

    def initialize
      @option_filters = []
      @handler_mapping = Hash.new { |h, k| h[k] = [] }
    end

    SEVERITIES.each do |severity|
      define_method(severity) do |exception_or_message, options = {}|
        log(severity, exception_or_message, Hash(options))
      end
    end

    private

    def log(severity, exception_or_message, options)
      process_option_filters(options)
      handler_mapping[severity].each do |handler|
        handler.call(exception_or_message, options)
      end
      nil
    rescue StandardError => e
      if options[:tablexi_logger_error]
        raise # recursion prevention
      else
        error(e, tablexi_logger_error: true)
      end
    end

    def process_option_filters(options)
      # rubocop:disable Style/SingleLineBlockParams
      option_filters.each_with_object(options) { |filter, opts| filter.call(opts) }
      # rubocop:enable Style/SingleLineBlockParams
    end
  end
end
