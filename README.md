# Tablexi::Logger

A standardized logging interface for Table XI applications.
The default behavior will log to `Rails.logger` or fallback to `::Logger.new($stdout)` if
Rails is not available. If [Rollbar](https://rollbar.com/) or [NewRelic](http://newrelic.com/)
are available, logging will also send events to the available service.

## Usage

Basic usage looks like this:

```ruby
Tablexi.logger.error "Bad Things Happened"
Tablexi.logger.error "Bad Request", request: request
Tablexi.logger.error "Request Timeout", metric: :timeout_error
```

You may also set the logger, for example configuring a null logger would look like this:

```ruby
Tablexi.logger = ::Logger.new(File.open(File::NULL, "w"))
```

## Extending Functionality

Applications may wish to customize logging – you can achieve this through monkeypatching
something like this:

```ruby
module LoggerWarning
  def warn(error, options = {})
    logger.warn error # logger exposes the underlying ::Logger
    notice_error(error, options.merge(priority: :warning) # notice_error handles error tracking service
  end
end

Tablexi::Logger.include LoggerWarning
Tablexi.logger.warn "You have been warned"
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
