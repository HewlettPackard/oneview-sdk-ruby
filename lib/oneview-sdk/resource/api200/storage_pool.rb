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

require_relative 'resource'

module OneviewSDK
  module API200
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
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['type'] ||= 'StoragePoolV2'
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create!(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def update(*)
        unavailable_method
      end

      # Retrieve resource details based on this resource's name or URI.
      # @note Name or URI must be specified inside the resource
      # @return [Boolean] Whether or not retrieve was successful
      def retrieve!
        raise IncompleteResource, 'Must set resource name or uri before trying to retrieve!' unless @data['name'] || @data['uri']
        raise IncompleteResource, 'Must set resource storageSystemUri before trying to retrieve!' unless @data['storageSystemUri']
        results = self.class.find_by(@client, name: @data['name'], storageSystemUri: @data['storageSystemUri']) if @data['name']
        results = self.class.find_by(@client, uri:  @data['uri'], storageSystemUri: @data['storageSystemUri']) if @data['uri'] &&
          (!results || results.empty?)
        return false unless results.size == 1
        set_all(results[0].data)
        true
      end

      # Check if a resource exists
      # @note name or uri must be specified inside resource
      # @return [Boolean] Whether or not resource exists
      def exists?
        raise IncompleteResource, 'Must set resource name or uri before trying to exists?' unless @data['name'] || @data['uri']
        raise IncompleteResource, 'Must set resource storageSystemUri before trying to exists?' unless @data['storageSystemUri']
        return true if @data['name'] && self.class.find_by(@client, name: @data['name'], storageSystemUri: @data['storageSystemUri']).size == 1
        return true if @data['uri']  && self.class.find_by(@client, uri:  @data['uri'], storageSystemUri: @data['storageSystemUri']).size == 1
        false
      end

      # Sets the storage system
      # @param [OneviewSDK::StorageSystem] storage_system
      # @raise [OneviewSDK::IncompleteResource] if Storage System not found
      def set_storage_system(storage_system)
        raise 'Storage System could not be found!' unless storage_system.retrieve!
        set('storageSystemUri', storage_system['uri'])
      end
    end
  end
end
