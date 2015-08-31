# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tablexi/logger/version'

Gem::Specification.new do |spec|
  spec.name          = "tablexi-logger"
  spec.version       = Tablexi::Logger::VERSION
  spec.authors       = ["Bradley Schaefer"]
  spec.email         = ["bradley.schaefer@gmail.com"]

  spec.summary       = %q{A simple logging wrapper to use in Table XI applications.}
  spec.description   = %q{Provides a single interface for logging so that applications do not need to be aware of NewRelic, Rollbar, or whatever else.}
  spec.homepage      = "https://github.com/tablexi/tablexi-logger"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    # prevent pushing this to RubyGems.org
    spec.metadata['allowed_push_host'] = "http://gems.tablexi.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
end
