require "tablexi/logger/severities"

module Tablexi
  class Logger
    class Standard
      include Tablexi::Logger::Severities

      attr_reader :logger
      attr_reader :severity

      def initialize(logger, options = {})
        defaults = { severity: :unknown }
        options = defaults.merge(options)
        severity = options[:severity]
        raise ArgumentError, "Severity `#{severity}` must be one of #{SEVERITIES}" unless SEVERITIES.include?(severity)

        @logger = logger
        @severity = severity
      end

      def call(exception_or_message, options)
        logger.public_send severity, generate_log(exception_or_message, options)
      end

      private

      def generate_log(exception_or_message, options)
        options = Hash[options]

        message = []
        message << (exception_or_message.respond_to?(:message) ? exception_or_message.message : exception_or_message)
        message << options.map { |k, v| "#{k}: #{v}" } if options.size > 0
        message << exception_or_message.backtrace if exception_or_message.respond_to?(:backtrace)
        message.flatten.join("\n")
      end
    end
  end
end
