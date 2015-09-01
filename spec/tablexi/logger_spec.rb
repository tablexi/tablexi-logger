require "spec_helper"

describe Tablexi::Logger do
  def with_logger(logger)
    original = Tablexi.logger
    Tablexi.logger = logger
    yield
  ensure
    Tablexi.logger = original
  end

  it "allows assigning the logger instance" do
    logger = spy("Logger")
    with_logger(logger) do
      expect(Tablexi.logger).to eq logger
    end
  end

  it "has a sensible default" do
    expect(Tablexi.logger).to be_a Tablexi::Logger
  end

  describe "default logger behavior" do
    Tablexi::Logger::SEVERITIES.each do |severity|
      it "calls ##{severity} on the underlying logger" do
        spy_logger = spy("Logger")
        logger = Tablexi.default_logger spy_logger
        logger.public_send(severity, "message")
        expect(spy_logger).to have_received(severity).with("message")
      end
    end
  end
end
