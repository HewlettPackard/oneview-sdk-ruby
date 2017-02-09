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
def_spec_options = '--color '
def_int_spec_options = '-f d --color '

desc 'Run unit tests only'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_spec_options
  spec.rspec_opts << ' --tag ~integration'
  spec.rspec_opts << ' --tag ~system'
  spec.rspec_opts << ' --tag ~integration_i3s'
end

desc 'Run integration tests only'
RSpec::Core::RakeTask.new('spec:integration') do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration'
end

desc 'Run integration creation tests only'
RSpec::Core::RakeTask.new('spec:integration:create') do |spec|
  spec.pattern = 'spec/**/*create_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration'
end

desc 'Run integration update tests only'
RSpec::Core::RakeTask.new('spec:integration:update') do |spec|
  spec.pattern = 'spec/**/*update_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration'
end

desc 'Run integration deletion tests only'
RSpec::Core::RakeTask.new('spec:integration:delete') do |spec|
  spec.pattern = 'spec/**/*delete_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag integration'
end

desc 'Run System tests'
RSpec::Core::RakeTask.new('spec:system') do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests for specified model & API. Defaults to model C7000 and API 300.'
task 'spec:system:api_version_model', [:api, :model] do |_t, spec|
  args = {}
  args['model'] = spec['model'] || 'c7000'
  args['api'] = spec['api'] || 300
  spec_pattern = "spec/system/**/api#{args['api']}/#{args['model']}/*_spec.rb"
  spec_pattern = 'spec/system/**/api200/*_spec.rb' if args['api'] == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests for specified API. Defaults to API 300.'
task 'spec:system:api_version', [:api] do |_t, spec|
  args = spec['api'] || 300
  spec_pattern = "spec/system/**/api#{args}/**/*_spec.rb"
  spec_pattern = 'spec/system/**/api200/*_spec.rb' if args == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests Light Profile'
RSpec::Core::RakeTask.new('spec:system:light') do |spec|
  spec.pattern = 'spec/system/light_profile/**/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests Light Profile for specified model & API. Defaults to model C7000 and API 300.'
task 'spec:system:light:api_version_model', [:api, :model] do |_t, spec|
  args = {}
  args['model'] = spec['model'] || 'c7000'
  args['api'] = spec['api'] || 300
  spec_pattern = "spec/system/light_profile/api#{args['api']}/#{args['model']}/*_spec.rb"
  spec_pattern = 'spec/system/light_profile/api200/*_spec.rb' if args['api'] == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests Light Profile for specified API. Defaults to API 300.'
task 'spec:system:light:api_version', [:api] do |_t, spec|
  args = spec['api'] || 300
  spec_pattern = "spec/system/light_profile/api#{args}/**/*_spec.rb"
  spec_pattern = 'spec/system/light_profile/api200/*_spec.rb' if args == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests Medium Profile'
RSpec::Core::RakeTask.new('spec:system:medium') do |spec|
  spec.pattern = 'spec/system/medium_profile/**/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests Medium Profile for specified model & API. Defaults to model C7000 and API 300.'
task 'spec:system:medium:api_version_model', [:api, :model] do |_t, spec|
  args = {}
  args['model'] = spec['model'] || 'c7000'
  args['api'] = spec['api'] || 300
  spec_pattern = "spec/system/medium_profile/api#{args['api']}/#{args['model']}/*_spec.rb"
  spec_pattern = 'spec/system/medium_profile/api200/*_spec.rb' if args['api'] == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests Medium Profile for specified API. Defaults to API 300.'
task 'spec:system:medium:api_version', [:api] do |_t, spec|
  args = spec['api'] || 300
  spec_pattern = "spec/system/medium_profile/api#{args}/**/*_spec.rb"
  spec_pattern = 'spec/system/medium_profile/api200/*_spec.rb' if args == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests Heavy Profile'
RSpec::Core::RakeTask.new('spec:system:heavy') do |spec|
  spec.pattern = 'spec/system/heavy_profile/**/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests Heavy Profile for specified model & API. Defaults to model C7000 and API 300.'
task 'spec:system:heavy:api_version_model', [:api, :model] do |_t, spec|
  args = {}
  args['model'] = spec['model'] || 'c7000'
  args['api'] = spec['api'] || 300
  spec_pattern = "spec/system/heavy_profile/api#{args['api']}/#{args['model']}/*_spec.rb"
  spec_pattern = 'spec/system/heavy_profile/api200/*_spec.rb' if args['api'] == '200'
  Rake::Task['spec:system'].invoke
end

desc 'Run System tests Heavy Profile for specified API. Defaults to API 300.'
task 'spec:system:heavy:api_version', [:api] do |_t, spec|
  args = spec['api'] || 300
  spec_pattern = "spec/system/heavy_profile/api#{args}/**/*_spec.rb"
  spec_pattern = 'spec/system/heavy_profile/api200/*_spec.rb' if args == '200'
  Rake::Task['spec:system'].invoke
end

RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

desc 'Runs rubocop and unit tests'
task :test do
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
end

desc 'Run rubocop, unit & integration tests'
task 'test:all' do
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
  Rake::Task['spec:integration'].invoke
  Rake::Task['spec:system'].invoke
end

desc 'Run rubocop & integration tests for specified path'
task 'test:path', [:path] do |_t, spec|
  spec_pattern = spec['path']
  Rake::Task[:rubocop].invoke
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
  # Rake::Task[:rubocop].invoke
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
  # Rake::Task[:rubocop].invoke
  Rake::Task['spec:integration:i3s'].invoke
end
