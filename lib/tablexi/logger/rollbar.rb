module Tablexi
  class Logger
    Rollbar = lambda do |error, options|
      ::Rollbar.error(error, options)
    end
  end
end
