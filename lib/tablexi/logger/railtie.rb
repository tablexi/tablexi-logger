module Tablexi
  class Logger
    class Railtie < Rails::Railtie
      config.after_initialize do |app|
        Tablexi.bare_logger = Rails.logger

        setup_lograge(app) if defined?(Lograge) && app.config.lograge.enabled
      end

      def setup_lograge(app)
        # since Lograge's after_initialize isn't guaranteed to run before this one
        # we need to make sure the setup occurs before we check lograge.logger
        Lograge.setup(app)

        return unless app.config.lograge.logger == Rails.logger

        # We need to preserve lograge file format integrity if lograge is using
        # Rails.logger - presumably error tracking services will report the errors
        # so they aren't swallowed silently.
        null_logger = ::Logger.new(File.open(File::NULL, "w"))
        Tablexi.bare_logger = null_logger
      end
    end
  end
end
