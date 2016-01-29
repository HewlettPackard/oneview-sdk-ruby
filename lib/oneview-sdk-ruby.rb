require_relative 'oneview-sdk-ruby/version'
require_relative 'oneview-sdk-ruby/client'
require_relative 'oneview-sdk-ruby/resource'
require_relative 'oneview-sdk-ruby/cli'

# Module for interracting with the HP OneView API
module OneviewSDK
  ENV_VARS = %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).freeze
end
