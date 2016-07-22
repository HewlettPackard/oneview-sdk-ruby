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
  # Storage pool resource implementation
  class StoragePool < Resource
    BASE_URI = '/rest/storage-pools'.freeze

    # Add the resource on OneView using the current data
    # @note Calls the refresh method to set additional data
    # @raise [OneviewSDK::IncompleteResource] if the client is not set
    # @raise [StandardError] if the resource creation fails
    # @return [OneviewSDK::StoragePool] self
    alias add create

    # Remove resource from OneView
    # @return [true] if resource was removed successfully
    alias remove delete

    # Create a resource object, associate it with a client, and set its properties.
    # @param [Client] client The Client object with a connection to the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'StoragePoolV2'
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

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def update
      unavailable_method
    end

    # Set storage system
    # @param [OneviewSDK::StorageSystem] storage_system
    def set_storage_system(storage_system)
      fail IncompleteResource, 'Please set the storage system\'s uri attribute!' unless storage_system['uri']
      set('storageSystemUri', storage_system['uri'])
    end
  end
end
