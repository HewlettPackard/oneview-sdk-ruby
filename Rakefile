require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec, [:arg1]) do |spec, args|
  spec.pattern = 'spec/integration/**/*_spec.rb'
  ENV['config_file'] = 'config/config.json' if args.arg1.nil?
end

RuboCop::RakeTask.new

desc 'Runs rubocop and rspec'
task :test do
  Rake::Task[:rubocop].invoke
  Rake::Task[:spec].invoke
end
