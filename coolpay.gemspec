# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coolpay/version'

Gem::Specification.new do |spec|
  spec.name          = 'coolpay'
  spec.version       = Coolpay::VERSION
  spec.authors       = ['Danny Smith']
  spec.email         = ['hi@danny.is']

  spec.summary       = 'Gem to wrap the Coolpay API.'
  spec.description   = 'Gem to wrap the Coolpay API.'
  spec.homepage      = 'http://github.com/dannysmith/coolpay'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'

  spec.add_dependency 'http'
  spec.add_dependency 'json'
end
