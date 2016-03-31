require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec

desc 'Run unit tests'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--tag ~integration --tag ~system'
end

desc 'Run integration tests'
RSpec::Core::RakeTask.new('spec:integration') do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--tag integration'
end

desc 'Run System tests'
RSpec::Core::RakeTask.new('spec:system') do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--tag system'
end

RuboCop::RakeTask.new

desc 'Runs rubocop and rspec'
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
