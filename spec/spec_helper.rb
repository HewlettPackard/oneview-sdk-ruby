require 'pry'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
  add_group 'Client', %w(client.rb rest.rb config_loader.rb)
  add_group 'Resources', 'lib/oneview-sdk-ruby/resource'
  add_group 'CLI', 'cli.rb'
  minimum_coverage 92 # TODO: bump up as we increase coverage.
  minimum_coverage_by_file 50 # TODO: bump up as we increase coverage.
end

require 'oneview-sdk-ruby'
require_relative 'shared_context'
require_relative 'support/fake_response.rb'

RSpec.configure do |config|
  config.before(:each) do
    allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(200)
    allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')

    # Clear environment variables
    %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).each do |name|
      ENV[name] = nil
    end
  end
end

# OneView::Config[:log_level] = :warn
