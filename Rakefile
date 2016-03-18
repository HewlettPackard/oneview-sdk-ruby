require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec
spec_pattern = 'spec/**/*_spec.rb'
def_spec_options = '--color '

desc 'Run unit tests only'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_spec_options
  spec.rspec_opts << '--tag ~integration'
end

desc 'Run integration tests only'
RSpec::Core::RakeTask.new('spec:integration') do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_spec_options
  spec.rspec_opts << '--tag integration'
end

desc 'Run unit and integration tests'
RSpec::Core::RakeTask.new('spec:all') do |spec|
  spec.pattern = spec_pattern
  spec.rspec_opts = def_spec_options
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
  Rake::Task['spec:all'].invoke
end
