# coding: utf-8
# http://guides.rubygems.org/specification-reference

require_relative './lib/oneview-sdk-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'oneview-sdk-ruby'
  spec.version       = OneviewSDK::VERSION
  spec.authors       = ['Henrique', 'Thiago', 'Jared Smartt']
  spec.email         = ['henrique.diomede@hpe.com', 'thiago.mio.amaral@hpe.com', 'jared.smartt@hpe.com']
  spec.summary       = 'Gem to interact with oneview API'
  spec.description   = 'Gem to interact with oneview API'
  spec.license       = 'Apache-2.0'
  spec.homepage      = 'https://github.com/HewlettPackard/oneview-sdk-ruby'

  all_files = `git ls-files -z`.split("\x0")
  spec.files         = all_files.reject { |f| f.match(%r{^(examples\/)|(spec\/)}) }
  spec.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'highline'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'

end
