# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'oneview-sdk/version'
require_relative 'oneview-sdk/exceptions'
require_relative 'oneview-sdk/client'
require_relative 'oneview-sdk/resource'
Dir[File.dirname(__FILE__) + '/oneview-sdk/resource/*.rb'].each { |file| require file }
require_relative 'oneview-sdk/cli'
require_relative 'oneview-sdk/image_streamer'

# Module for interacting with the HPE OneView API
module OneviewSDK
  env_i3s = %w(I3S_URL I3S_TOKEN I3S_SSL_ENABLED)
  ENV_VARS = %w(ONEVIEWSDK_URL ONEVIEWSDK_USER ONEVIEWSDK_PASSWORD ONEVIEWSDK_TOKEN ONEVIEWSDK_SSL_ENABLED).concat(env_i3s).freeze

  SUPPORTED_API_VERSIONS = [200, 300].freeze
  DEFAULT_API_VERSION = 200
  @api_version = DEFAULT_API_VERSION
  @api_version_updated = false # Whether or not the API version has been set by the user

  # Get the current API version
  def self.api_version
    @api_version
  end

  # Set the default API version
  def self.api_version=(version)
    version = version.to_i rescue version
    raise "API version #{version} is not supported!" unless SUPPORTED_API_VERSIONS.include?(version)
    raise "The module for API version #{@api_version} is undefined" unless constants.include?("API#{@api_version}".to_sym)
    @api_version_updated = true
    @api_version = version
  end

  # Has the API version been set by the user?
  # @return [TrueClass, FalseClass]
  def self.api_version_updated?
    @api_version_updated
  end

  # This method will help redirect to resources within the API module that is currently in use.
  # It should NOT be called directly. For example, if @@api_version is set to 200, then accessing
  # OneviewSDK::EthernetNetwork will redirect to OneviewSDK::API200::EthernetNetwork
  def self.const_missing(const)
    api_module = OneviewSDK.const_get("API#{@api_version}")
    api_module.const_get(const)
  rescue NameError
    raise NameError, "The #{const} method or resource does not exist for OneView API version #{@api_version}."
  end
end
