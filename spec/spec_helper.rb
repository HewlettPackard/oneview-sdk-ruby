require 'pry'
require 'simplecov'
require 'coveralls'

client_files = %w(client.rb rest.rb config_loader.rb ssl_helper.rb image-streamer/client.rb)
resource_path = 'lib/oneview-sdk/resource'
image_streamer_path = 'lib/oneview-sdk/image-streamer/resource'

Coveralls.wear!

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.profiles.define 'unit' do
  add_filter 'spec/'
  add_group 'Client', client_files
  add_group 'Resources', resource_path
  add_group 'CLI', 'cli.rb'
  add_group 'Image Streamer', image_streamer_path
  minimum_coverage 92 # TODO: bump up as we increase coverage. Goal: 95%
  minimum_coverage_by_file 61 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'integration' do
  add_filter 'spec/'
  add_filter 'cli.rb'
  add_filter '../lib/oneview-sdk/image-streamer/'
  add_filter '../lib/oneview-sdk/image_streamer.rb'
  add_group 'Client', client_files
  add_group 'Resources', resource_path
  minimum_coverage 50 # TODO: bump up as we increase coverage. Goal: 85%
  minimum_coverage_by_file 30 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'system' do
  add_filter 'spec/'
  add_filter 'cli.rb'
  add_group 'Client', client_files
  add_group 'Resources', resource_path
  minimum_coverage 50 # TODO: bump up as we increase coverage. Goal: 85%
  minimum_coverage_by_file 30 # TODO: bump up as we increase coverage. Goal: 70%
end

SimpleCov.profiles.define 'integration_i3s' do
  add_filter 'spec/'
  add_filter 'cli.rb'
  add_filter '../lib/oneview-sdk/resource'
  add_group 'Client', client_files
  add_group 'Resources', image_streamer_path
  minimum_coverage 50 # TODO: bump up as we increase coverage. Goal: 85%
  minimum_coverage_by_file 30 # TODO: bump up as we increase coverage. Goal: 70%
end


SimpleCov.profiles.define 'all' do
  add_filter 'spec/'
  add_group 'Client', client_files
  add_group 'Resources', resource_path
  add_group 'CLI', 'cli.rb'
  add_group 'Image Streamer', image_streamer_path
  minimum_coverage 10 # TODO: bump up as we increase coverage. Goal: 95%
  minimum_coverage_by_file 10 # TODO: bump up as we increase coverage. Goal: 90%
end

if RSpec.configuration.filter_manager.inclusions.rules[:integration] # Run Integration only
  SimpleCov.start 'integration'
elsif RSpec.configuration.filter_manager.inclusions.rules[:system] # Run System only
  SimpleCov.start 'system'
elsif RSpec.configuration.filter_manager.exclusions.rules[:integration] && RSpec.configuration.filter_manager.exclusions.rules[:system]
  SimpleCov.start 'unit'
elsif RSpec.configuration.filter_manager.inclusions.rules[:integration_i3s] # Run Integration for i3s only
  SimpleCov.start 'integration_i3s'
else # Run both
  SimpleCov.start 'all'
end

require 'oneview-sdk'
require_relative '../lib/oneview-sdk/image_streamer'
require_relative 'shared_context'
require_relative 'support/fake_response'
require_relative 'integration/sequence_and_naming'
require_relative 'integration/sequence_and_naming_i3s'
Dir["#{File.dirname(__FILE__)}/integration/shared_examples/**/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/system/shared_examples/**/*.rb"].each { |file| require file }
require_relative 'helpers'

RSpec.configure do |config|
  config.include Helpers

  # Sort integration and system tests
  if config.filter_manager.inclusions.rules[:integration] || config.filter_manager.inclusions.rules[:system] ||
      config.filter_manager.inclusions.rules[:integration_i3s]
    config.register_ordering(:global) do |items|
      items.sort_by { |i| [(i.metadata[:type] || 0), (i.metadata[:sequence] || 100)] }
    end
  end

  config.before(:each) do
    unless config.filter_manager.inclusions.rules[:integration] || config.filter_manager.inclusions.rules[:system]
      # Mock appliance version and login api requests, as well as loading trusted certs
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(500)
      allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')
      allow_any_instance_of(OneviewSDK::ImageStreamer::Client).to receive(:appliance_i3s_api_version).and_return(300)
      allow(OneviewSDK::SSLHelper).to receive(:load_trusted_certs).and_return(nil)
    end

    # Clear environment variables
    OneviewSDK::ENV_VARS.each do |name|
      ENV[name] = nil
    end
  end

  # Rspec color configurations Start
  config.color = true
  config.tty = true
  # Rspec color configurations End

end
