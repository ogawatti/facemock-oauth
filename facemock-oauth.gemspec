# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facemock/oauth/version'

Gem::Specification.new do |spec|
  spec.name          = "facemock-oauth"
  spec.version       = Facemock::OAuth::VERSION
  spec.authors       = ["ogawatti"]
  spec.email         = ["ogawattim@gmail.com"]
  spec.description   = %q{This gem will mock the oauth of facebook using facemock.}
  spec.summary       = %q{This is facebook oauth mock application.}
  spec.homepage      = "https://github.com/ogawatti/facemock-oauth"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "facemock"
  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"
end
