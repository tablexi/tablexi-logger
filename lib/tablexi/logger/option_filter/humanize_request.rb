module Tablexi
  class Logger
    module OptionFilter
      HumanizeRequest = lambda do |options|
        return options unless options.key? :request

        request = options.delete :request
        body = request.body.read
        request.body.rewind

        options[:http_method] = request.headers["REQUEST_METHOD"]
        options[:uri] = request.original_url
        options[:body] = body
        options
      end
    end
  end
end
