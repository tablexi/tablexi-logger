# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tablexi/logger/version"

Gem::Specification.new do |spec|
  spec.name          = "tablexi-logger"
  spec.version       = Tablexi::Logger::VERSION
  spec.authors       = ["Table XI Partners LLC", "Bradley Schaefer"]
  spec.email         = ["bradley.schaefer@gmail.com"]

  spec.summary       = "A simple logging wrapper to use in Table XI applications."
  spec.description   = "Provides a single interface for logging so that applications do not need to be aware of NewRelic, Rollbar, or whatever else."
  spec.homepage      = "https://github.com/tablexi/tablexi-logger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rubocop"
end
