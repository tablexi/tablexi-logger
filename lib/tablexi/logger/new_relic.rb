module Tablexi
  class Logger
    NewRelic = lambda do |error, options|
      ::NewRelic::Agent.notice_error(error, options)
    end
  end
end
