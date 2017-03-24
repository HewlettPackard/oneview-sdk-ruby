# coding: utf-8
# http://guides.rubygems.org/specification-reference

# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative './lib/oneview-sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'oneview-sdk'
  spec.version       = OneviewSDK::VERSION
  spec.authors       = ['Henrique Diomede', 'Thiago Miotto', 'Jared Smartt', 'Ricardo Piantola']
  spec.email         = ['henrique.diomede@hpe.com', 'tmiotto@hpe.com', 'jared.smartt@hpe.com', 'piantola@hpe.com']
  spec.summary       = 'Gem to interact with the HPE OneView API'
  spec.description   = 'Gem to interact with the HPE OneView API'
  spec.license       = 'Apache-2.0'
  spec.homepage      = 'https://github.com/HewlettPackard/oneview-sdk-ruby'

  all_files          = `git ls-files -z`.split("\x0")
  spec.files         = all_files.reject { |f| f.match(%r{(^examples\/)|(^spec\/)|(^\.)}) }
  spec.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'highline'
  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'multipart-post'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '= 0.42.0'
  spec.add_development_dependency 'simplecov'
end
