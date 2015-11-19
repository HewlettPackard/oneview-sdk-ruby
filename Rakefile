require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec

desc 'Run unit tests'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--tag ~integration'
end

desc 'Run integration tests'
RSpec::Core::RakeTask.new('spec:integration') do |spec|
  unless ENV['ONEVIEWSDK_INTEGRATION_CONFIG'] && ENV['ONEVIEWSDK_INTEGRATION_SECRETS']
    vars = "'ONEVIEWSDK_INTEGRATION_CONFIG' & 'ONEVIEWSDK_INTEGRATION_SECRETS'"
    puts "\nERROR: Must set the #{vars} environment variables first!\n"
    exit 1
  end
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--tag integration'
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
end
