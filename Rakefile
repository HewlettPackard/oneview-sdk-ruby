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

require 'bundler'
require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec
spec_pattern = 'spec/**/*_spec.rb'
integration_pattern = 'spec/integration/resource/**/*_spec.rb'
integration_i3s_pattern = 'spec/integration/image-streamer/**/*_spec.rb'
system_pattern = 'spec/system/**/*_spec.rb'
def_spec_options = '--color '
def_int_spec_options = '-f d --color '

# Run RuboCop before integration/system tests if ENV['RUBOCOP_FIRST'] is set
def rubocop_first
  return Rake::Task[:rubocop].invoke if ENV['RUBOCOP_FIRST']
  puts "Note: Set ENV['RUBOCOP_FIRST'] to run RuboCop before any integration or system tests\n\n"
end

RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

desc 'Run unit tests only'
RSpec::Core::RakeTask.new(:unit) do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_spec_options
  spec.rspec_opts << ' --tag ~integration'
  spec.rspec_opts << ' --tag ~system'
  spec.rspec_opts << ' --tag ~integration_i3s'
end

desc 'Alias for "unit"'
task spec: [:unit]

desc 'Run integration tests only'
RSpec::Core::RakeTask.new(:integration) do |spec|
  spec.pattern = integration_pattern
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration'
  rubocop_first
end

desc 'Run integration tests (filtered). Default: [*,**,*]'
task 'integration:only', [:action, :type, :api_ver, :variant] do |_t, args|
  args.with_defaults(action: '*', type: '**', api_ver: '*', variant: '**')
  pattern = "#{args['api_ver']}/#{args['type']}/#{args['action']}" if args['api_ver'] == '200'
  pattern ||= "#{args['api_ver']}/#{args['variant']}/#{args['type']}/#{args['action']}"
  integration_pattern = "spec/integration/resource/api#{pattern}_spec.rb"
  Rake::Task[:integration].invoke
end

desc 'Integration tests for the specified path'
task 'integration:path', [:path] do |_t, args|
  integration_pattern = args['path']
  Rake::Task[:integration].invoke
end

desc 'Run Image Streamer integration tests'
RSpec::Core::RakeTask.new('integration_i3s') do |spec|
  spec.pattern = integration_i3s_pattern
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration_i3s'
  rubocop_first
end

desc 'Run Image Streamer integration tests (filtered). Default: [,**,*]'
task 'integration_i3s:only', [:action, :type, :api_ver] do |_t, args|
  args.with_defaults(action: '', type: '**', api_ver: '*')
  Rake::Task[:rubocop].invoke if ENV['RUBOCOP_FIRST']
  integration_i3s_pattern = "spec/integration/image-streamer/api#{args['api_ver']}/#{args['type']}/*#{args['action']}_spec.rb"
  Rake::Task['integration_i3s'].invoke
end

desc 'Run Image Streamer integration tests for the specified path'
task 'integration_i3s:path', [:path] do |_t, args|
  integration_i3s_pattern = args['path']
  Rake::Task['integration_i3s'].invoke
end

desc 'Run system integration tests'
RSpec::Core::RakeTask.new(:system) do |spec|
  spec.pattern = system_pattern
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
  rubocop_first
end

desc 'Run system integration tests (filtered) Default: [*,**,*]'
task 'system:only', [:api_ver, :variant, :profile] do |_t, args|
  args.with_defaults(api_ver: '*', variant: '**', profile: '*')
  system_pattern = "spec/system/#{args['profile']}_profile/api#{args['api_ver']}/#{args['variant']}/*_spec.rb"
  Rake::Task[:system].invoke
end

desc 'Run system integration tests for the specified path'
task 'system:path', [:path] do |_t, args|
  system_pattern = args['path']
  Rake::Task[:system].invoke
end

desc 'Runs RuboCop and unit tests'
task :test do
  Rake::Task[:rubocop].invoke
  Rake::Task[:unit].invoke
end

desc 'Run RuboCop, unit, integration & system tests'
task 'test:all' do
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
  Rake::Task['spec:integration'].invoke
  Rake::Task['spec:system'].invoke
end

desc 'Run rubocop & integration tests for specified path'
task 'test:path', [:path] do |_t, spec|
  spec_pattern = spec['path']
  # Rake::Task[:rubocop].invoke
  Rake::Task['spec:integration'].invoke
end

desc 'Run rubocop & integration tests for specified API version & model. Default: [300,c7000]'
task 'spec:integration:api', [:version, :model] do |_t, spec|
  version = spec['version'] || 300
  model = spec['model'] || 'c7000'
  spec_pattern = "spec/integration/resource/api#{version}/#{model}/**/*_spec.rb"
  spec_pattern = 'spec/integration/resource/api200/**/*_spec.rb' if version.to_s == '200'
  Rake::Task[:rubocop].invoke
  Rake::Task['spec:integration'].invoke
end

desc 'Run rubocop & integration tests for specified API version. Default: 300'
task 'spec:integration:api_version', [:ver] do |_t, spec|
  version = spec['ver'] || 300
  spec_pattern = "spec/integration/resource/api#{version}/**/**/*_spec.rb"
  spec_pattern = 'spec/integration/resource/api200/**/*_spec.rb' if version.to_s == '200'
  Rake::Task[:rubocop].invoke
  Rake::Task['spec:integration'].invoke
end

desc 'Run rubocop & integration deletion tests for specified API version. Default: 300'
task 'spec:integration:delete:api_version', [:ver] do |_t, spec|
  version = spec['ver'] || 300
  spec_pattern = "spec/integration/resource/api#{version}/**/**/*delete_spec.rb"
  spec_pattern = 'spec/integration/resource/api200/**/*delete_spec.rb' if version.to_s == '200'
  Rake::Task[:rubocop].invoke
  Rake::Task['spec:integration'].invoke
end

desc 'Run rubocop & integration tests for Image Streamer.'
RSpec::Core::RakeTask.new('spec:integration:i3s') do |spec|
  Rake::Task[:rubocop].invoke
  spec.pattern = spec_pattern
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration_i3s'
end

desc 'Run rubocop & integration creation tests for Image Streamer only'
RSpec::Core::RakeTask.new('spec:integration:i3s:create') do |spec|
  Rake::Task[:rubocop].invoke
  spec.pattern = 'spec/**/*create_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration_i3s'
end

desc 'Run rubocop & integration update tests for Image Streamer only'
RSpec::Core::RakeTask.new('spec:integration:i3s:update') do |spec|
  Rake::Task[:rubocop].invoke
  spec.pattern = 'spec/**/*update_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration_i3s'
end

desc 'Run rubocop & integration deletion tests for Image Streamer only'
RSpec::Core::RakeTask.new('spec:integration:i3s:delete') do |spec|
  Rake::Task[:rubocop].invoke
  spec.pattern = 'spec/**/*delete_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration_i3s'
end

desc 'Run rubocop & integration tests for specified API version of Image Streamer. Default: 300'
task 'spec:integration:i3s:api_version', [:ver] do |_t, spec|
  version = spec['ver'] || 300
  spec_pattern = "spec/integration/image-streamer/api#{version}/**/*_spec.rb"
  Rake::Task['spec:integration:i3s'].invoke
end

desc 'Run rubocop & integration tests for Image Streamer & specified path'
task 'test:i3s:path', [:path] do |_t, spec|
  spec_pattern = spec['path']
  Rake::Task['spec:integration:i3s'].invoke
end
