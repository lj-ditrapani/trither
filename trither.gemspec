# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trither/version'

Gem::Specification.new do |spec|
  spec.name          = 'trither'
  spec.version       = Trither::VERSION
  spec.authors       = ['Lyall Jonathan Di Trapani']
  spec.email         = ['lj.ditrapani@gmail.com']

  spec.summary       = 'Simple implementations of Try, Either, and Option'
  spec.description   =
    'Very simple implementations of Try, Either, and Option inspired by Scala'
  spec.homepage      = 'https://github.com/lj-ditrapani/trither'
  spec.license       = 'MIT'

  spec.files = %w(
    lib/trither.rb
    lib/trither/version.rb
    lib/trither/try.rb
    lib/trither/either.rb
    lib/trither/option.rb
  )
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'contracts', '~> 0.14'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0'
end
