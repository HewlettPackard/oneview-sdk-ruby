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
  # Storage system resource implementation
  class UnmanagedDevice < Resource
    BASE_URI = '/rest/unmanaged-devices'.freeze

    # Add the resource on OneView using the current data
    # @note Calls the refresh method to set additional data
    # @raise [OneviewSDK::IncompleteResource] if the client is not set
    # @raise [StandardError] if the resource creation fails
    # @return [OneviewSDK::UnmanagedDevice] self
    alias add create

    # Remove resource from OneView
    # @return [true] if resource was removed successfully
    alias remove delete

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

    # Gets a list of unmanaged devices
    # @param [OneviewSDK::Client] client HPE OneView client
    # @return [Array] list of unmanaged devices
    def self.get_devices(client)
      response = client.rest_get(BASE_URI)
      client.response_handler(response)['members']
    end

    # Get settings that describe the environmental configuration
    def environmental_configuration
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/environmentalConfiguration')
      @client.response_handler(response)
    end
  end
end
