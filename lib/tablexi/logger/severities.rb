module Tablexi
  class Logger
    module Severities
      SEVERITIES = %i(
        debug
        info
        warn
        error
        fatal
        unknown
      ).freeze
    end
  end
end
