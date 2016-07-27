# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewSDK
  # SAN manager resource implementation
  class SANManager < Resource
    BASE_URI = '/rest/fc-sans/device-managers'.freeze
    PROVIDERS_URI = '/rest/fc-sans/providers'.freeze

    # Remove resource from OneView
    # @return [true] if resource was removed successfully
    alias remove delete

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] = 'FCDeviceManagerV2'
    end

    # Adds the resource on OneView using the current data
    # @return [OneviewSDK::SANManager] self
    def add
      ensure_client
      fail 'providerDisplayName' unless @data['providerDisplayName']
      @data['providerUri'] = get_provider_uri
      response = @client.rest_post(@data['providerUri'] + '/device-managers', { 'body' => @data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def create
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def delete
      unavailable_method
    end

    # Refreshes the san manager state or change connection information
    # @param [Hash] options
    def update(options)
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'], 'body' => options)
      new_data = @client.response_handler(response)
      set_all(new_data)
    end

    # Retrieves the default connection information for a specific provider
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [String] provider_name Providers name
    # @return [Hash] A hash with default connectionInfo information
    def self.get_default_connection_info(client, provider_name)
      response = client.rest_get(PROVIDERS_URI)
      providers = client.response_handler(response)['members']
      desired_provider = providers.find { |provider| provider['displayName'] == provider_name || provider['name'] == provider_name }
      desired_provider['defaultConnectionInfo']
    end

    private

    # Gets the provider uri
    # @return [String] provider uri
    def get_provider_uri
      return @data['providerUri'] if @data['providerUri']
      response = @client.rest_get(PROVIDERS_URI)
      providers = @client.response_handler(response)['members']
      desired_provider = providers.find { |provider| provider['displayName'] == @data['providerDisplayName'] }
      desired_provider['uri']
    end
  end
end
