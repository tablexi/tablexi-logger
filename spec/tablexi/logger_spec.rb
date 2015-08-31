require "spec_helper"

describe Tablexi::Logger do
  def with_logger(logger)
    original = Tablexi.logger
    Tablexi.logger = logger
    yield
  ensure
    Tablexi.logger = original
  end

  it "calls the underlying logger #error" do
    logger = spy("Logger")
    with_logger(logger) do
      logger.error "hi"
    end
    expect(logger).to have_received(:error).with("hi")
  end
end
