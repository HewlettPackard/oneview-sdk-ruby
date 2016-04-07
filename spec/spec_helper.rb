require 'pry'
require 'simplecov'

SimpleCov.profiles.define 'unit' do
  add_filter 'spec/'
  add_group 'Client', %w(client.rb rest.rb config_loader.rb)
  add_group 'Resources', 'lib/oneview-sdk-ruby/resource'
  add_group 'CLI', 'cli.rb'
  minimum_coverage 89 # TODO: bump up as we increase coverage. Goal: 90%
  minimum_coverage_by_file 50 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'integration' do
  add_filter 'spec/'
  add_filter 'cli.rb'
  add_group 'Client', %w(client.rb rest.rb config_loader.rb)
  add_group 'Resources', 'lib/oneview-sdk-ruby/resource'
  minimum_coverage 50 # TODO: bump up as we increase coverage. Goal: 85%
  minimum_coverage_by_file 30 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'system_test' do
  add_filter 'spec/'
  add_filter 'cli.rb'
  add_group 'Client', %w(client.rb rest.rb config_loader.rb)
  add_group 'Resources', 'lib/oneview-sdk-ruby/resource'
  minimum_coverage 50 # TODO: bump up as we increase coverage. Goal: 85%
  minimum_coverage_by_file 30 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'all' do
  add_filter 'spec/'
  add_group 'Client', %w(client.rb rest.rb config_loader.rb)
  add_group 'Resources', 'lib/oneview-sdk-ruby/resource'
  add_group 'CLI', 'cli.rb'
  minimum_coverage 10 # TODO: bump up as we increase coverage. Goal: 95%
  minimum_coverage_by_file 10 # TODO: bump up as we increase coverage. Goal: 90%
end

if RSpec.configuration.filter_manager.inclusions.rules[:integration] # Run Integration only
  SimpleCov.start 'integration'
elsif RSpec.configuration.filter_manager.inclusions.rules[:system_test] # Run System only
  SimpleCov.start 'system_test'
elsif RSpec.configuration.filter_manager.exclusions.rules[:integration] && RSpec.configuration.filter_manager.exclusions.rules[:system_test]
  SimpleCov.start 'unit'
else # Run both
  SimpleCov.start 'all'
end

require 'oneview-sdk-ruby'
require_relative 'shared_context'
require_relative 'support/fake_response'
require_relative 'integration/sequence_and_naming'
require_relative 'system/light_profile/resource_names'


RSpec.configure do |config|
  # Sort integration tests
  unless config.filter_manager.exclusions.rules[:integration]
    config.register_ordering(:global) do |items|
      items.sort_by { |i| [(i.metadata[:type] || 0), (i.metadata[:sequence] || 100)] }
    end
  end

  unless config.filter_manager.exclusions.rules[:system_test]
    config.register_ordering(:global) do |items|
      items.sort_by { |i| [(i.metadata[:sequence] || 100)] }
    end
  end

  config.before(:each) do
    unless config.filter_manager.inclusions.rules[:integration] || config.filter_manager.inclusions.rules[:system_test]
      # Mock appliance version and login api requests
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(200)
      allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')
    end

    # Clear environment variables
    %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).each do |name|
      ENV[name] = nil
    end
  end
end
