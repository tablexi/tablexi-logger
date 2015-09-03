# Tablexi::Logger

[![Gem Version](https://badge.fury.io/rb/tablexi-logger.svg)](http://badge.fury.io/rb/tablexi-logger) [![Circle CI](https://circleci.com/gh/tablexi/tablexi-logger.svg?style=shield)](https://circleci.com/gh/tablexi/tablexi-logger)

Standardized logging for Table XI applications.

The default behavior will log to `Rails.logger` or fallback to `::Logger.new($stdout)` if
Rails is not available. If [Rollbar](https://rollbar.com/) or [NewRelic](http://newrelic.com/)
are available, logging will also send events to the available service for log levels `error`
or higher.

## Usage

Basic usage looks like this:

```ruby
Tablexi.logger.warn "Missing configuration, using default"
Tablexi.logger.error "Bad Things Happened"
Tablexi.logger.error "Bad Request", request: request
Tablexi.logger.error "Request Timeout", metric: :timeout_error
```

You may also assign the logger, for example configuring a null logger would look like this:

```ruby
Tablexi.logger = Tablexi::Logger.new # not configured with any handlers, so does nothing
```

## Extending Functionality

### Options Filtering

Applications may wish to modify the options passed to error handlers - for example
a `Tablexi::Logger::OptionFilter::HumanizeRequest` is provided by default, which
takes any `options[:request]` value and splits out the interesting parts such as
request method and body, and excludes the spammy parts such as headers.

Option filters may be configured via the `Tablexi::Logger#option_filters` array
with a callable:

```ruby
Tablexi.logger.option_filters << ->(options) { options.delete(:password) }  
```

### Registering logging handlers

Custom logging handlers implement callable and may be registered by log level (e.g. `:debug`):

```ruby
Tablexi.logger.handlers[:debug] << ->(error, options) { puts [error, options].join("\n") }

# Or to register multiple severities at once
Tablexi.logger.handle [:debug, :warn, :info] do |*args|
  puts args.join("\n")
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
