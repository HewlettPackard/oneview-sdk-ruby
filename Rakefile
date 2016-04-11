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

desc 'Run unit, integration and system tests'
RSpec::Core::RakeTask.new('spec:all') do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_spec_options
end

desc 'Run System tests'
RSpec::Core::RakeTask.new('spec:system') do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests Light Profile'
RSpec::Core::RakeTask.new('spec:system:light') do |spec|
  spec.pattern = 'spec/system/light_profile/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests Medium Profile'
RSpec::Core::RakeTask.new('spec:system:medium') do |spec|
  spec.pattern = 'spec/system/medium_profile/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

desc 'Run System tests Heavy Profile'
RSpec::Core::RakeTask.new('spec:system:heavy') do |spec|
  spec.pattern = 'spec/system/heavy_profile/*_spec.rb'
  spec.rspec_opts = def_int_spec_options
  spec.rspec_opts << ' --tag system'
end

RuboCop::RakeTask.new

desc 'Runs rubocop and unit tests'
task :test do
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
end

desc 'Run rubocop, unit & integration tests'
task 'test:all' do
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
  Rake::Task['spec:all'].invoke
end
