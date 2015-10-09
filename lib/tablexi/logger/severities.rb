module Tablexi
  class Logger
    module Severities
      SEVERITIES = [
        :debug,
        :info,
        :warn,
        :error,
        :fatal,
        :unknown,
      ].freeze
    end
  end
end
