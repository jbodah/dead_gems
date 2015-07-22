# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dead_gems/version'

Gem::Specification.new do |spec|
  spec.name          = "dead_gems"
  spec.version       = DeadGems::VERSION
  spec.authors       = ["Josh Bodah"]
  spec.email         = ["jb3689@yahoo.com"]
  spec.summary       = %q{a gem for finding unused gems in your project}
  spec.description   = %q{dead_gems works by analyzing your gem dependencies and running an exerciser script to see if any of them were used}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"

  spec.add_dependency "thor"
  spec.add_dependency "spy_rb"
end
