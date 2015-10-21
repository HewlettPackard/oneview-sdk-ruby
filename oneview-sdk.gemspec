# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unles $LOAD_PATH.include?(lib)
require 'oneview/version'


Gem::Specification.new do |spec|
  spec.name          = 'oneview-sdk-ruby'
  spec.version       = Oneview::VERSION
  spec.authors       = ['Henrique', 'Thiago']
  spec.email         = ['henrique.diomede@hpe.com', 'thiago.mio.amaral@hpe.com']
  spec.summary       = %q{Gem to interact with oneview API}
  spec.description   = %q{Gem to interact with oneview API}
  spec.license       = 'MIT'  

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)}) 
  spec.require_paths = ['lib']

  # spec.add_dependency ''
  
  spec.add_development_dependency 'bundler'
end
