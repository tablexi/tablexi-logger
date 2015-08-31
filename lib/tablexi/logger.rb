require "logger"
require "delegate"
require "tablexi/logger/version"

module Tablexi
  class << self
    def logger=(logger)
      @logger = logger.is_a?(Logger) ? logger : Logger.new(logger)
    end

    def logger
      @logger ||= begin
        Logger.new Rails.logger
      rescue StandardError
        stdout_log = ::Logger.new($stdout).tap do |config|
          config.level = ::Logger::DEBUG
        end
        Logger.new stdout_log
      end
    end
  end

  class Logger
    def initialize(logger)
      @logger = logger
    end

    def error(exception_or_message, options = {})
      humanize_request_metadata options

      message = []
      message << (exception_or_message.respond_to?(:message) ? exception_or_message.message : exception_or_message)
      message << options.map { |k, v| "#{k}: #{v}"} if options.size > 0
      message << exception_or_message.backtrace if exception_or_message.respond_to?(:backtrace)

      logger.error message.flatten.join("\n")
      notice_error(exception_or_message, options)
      nil
    end

    private

    private def logger; @logger end

    if defined?(Rollbar)
      def notice_error(error, options)
        Rollbar.error(error, options)
      end
    elsif defined?(NewRelic)
      def notice_error(error, options)
        NewRelic::Agent.notice_error(error, options)
      end
    else
      def notice_error(*); end
    end

    def humanize_request_metadata(options)
      return unless options.has_key? :request

      request = options.delete :request
      body = request.body.read
      request.body.rewind

      options[:http_method] = request.headers["REQUEST_METHOD"]
      options[:uri] = request.original_url
      options[:body] = body
    rescue StandardError => exception
      error exception
    end
  end
end
