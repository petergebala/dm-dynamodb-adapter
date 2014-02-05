# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dm-dynamodb-adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "dm-dynamodb-adapter"
  spec.version       = Dm::Dynamodb::Adapter::VERSION
  spec.authors       = ["Piotr Gębala", "Bartłomiej Oleszczyk"]
  spec.email         = ["piotrek.gebala@gmail.com", "bart@primate.co.uk"]
  spec.description   = %q{DynamoDb adapter to DataMapper}
  spec.summary       = %q{DynamoDb adapter to DataMapper}
  spec.homepage      = "http://github.com/petergebala/dm-dynamodb-adapter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_runtime_dependency 'dm-core', '~> 1.2.1'
  spec.add_runtime_dependency 'dm-aggregates'
  spec.add_runtime_dependency 'aws-sdk'
end
