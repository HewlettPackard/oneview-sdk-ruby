require 'pry'
require 'simplecov'
SimpleCov.start

require 'oneview-sdk-ruby'
require_relative 'shared_context'
require_relative 'support/fake_request.rb'

RSpec.configure do |config|
  config.before(:each) do
    allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(200)
    allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_return('secretToken')

    # Clear environment variables
    %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN).each do |name|
      ENV[name] = nil
    end
  end
end

# OneView::Config[:log_level] = :warn
