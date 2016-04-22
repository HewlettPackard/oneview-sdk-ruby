require_relative 'oneview-sdk/version'
require_relative 'oneview-sdk/client'
require_relative 'oneview-sdk/resource'
require_relative 'oneview-sdk/cli'

# Module for interracting with the HPE OneView API
module OneviewSDK
  ENV_VARS = %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).freeze
end
