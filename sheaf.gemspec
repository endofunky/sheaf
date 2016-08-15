# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sheaf/version'

Gem::Specification.new do |gem|
  gem.name          = "sheaf"
  gem.version       = Sheaf::VERSION
  gem.authors       = ["Tobias Svensson"]
  gem.email         = ["tob@tobiassvensson.co.uk"]
  gem.summary       = %q{Immutable, composable, multi-purpose middleware stack for Ruby}
  gem.description   = gem.summary
  gem.homepage      = "https://github.com/endofunky/sheaf"
  gem.license       = "Apache License, Version 2.0"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "minitest", "~> 5.5.1"
end
