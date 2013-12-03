# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'great_schools/version'

Gem::Specification.new do |spec|
  spec.name          = 'great_schools'
  spec.version       = GreatSchools::Version
  spec.authors       = ['Michael J. Sepcot']
  spec.email         = ['developer@sepcot.com']
  spec.description   = %q{The GreatSchools API allows access to School Profiles, Test Scores, School Reviews, GreatSchools Ratings, School Districts, and City Profiles.}
  spec.summary       = %q{A Ruby interface to the GreatSchools API.}
  spec.homepage      = 'https://github.com/msepcot/great_schools'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'fakeweb'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'activesupport', '>= 3.0.0'
  spec.add_dependency 'httparty', '~> 0.12.0'
end
