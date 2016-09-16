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
    # Volume template resource implementation
    class VolumeTemplate < Resource
      BASE_URI = '/rest/storage-volume-templates'.freeze

      # Create the client object, establishes connection, and set up the logging and api version.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      # Defaults to client.api_version if exists, or OneviewSDK::Client::DEFAULT_API_VERSION.
      # Defaults type to StorageVolumeTemplate when API version is 120
      # Defaults type to StorageVolumeTemplateV3 when API version is 200
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['provisioning'] ||= {}
        @data['type'] ||= 'StorageVolumeTemplateV3'
      end

      # Create the resource on OneView using the current data
      # @note Calls refresh method to set additional data
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create
        ensure_client
        response = @client.rest_post(self.class::BASE_URI, { 'Accept-Language' => 'en_US', 'body' => @data }, @api_version)
        body = @client.response_handler(response)
        set_all(body)
      end

      # Deletes the volume template from OneView
      # @return [TrueClass] if the volume template was deleted successfully
      def delete
        ensure_client && ensure_uri
        response = @client.rest_delete(@data['uri'], { 'Accept-Language' => 'en_US' }, @api_version)
        @client.response_handler(response)
        true
      end

      # Updates the volume template from OneView
      # @return [Resource] self
      def update(attributes = {})
        set_all(attributes)
        ensure_client && ensure_uri
        response = @client.rest_put(@data['uri'], { 'Accept-Language' => 'en_US', 'body' => @data }, @api_version)
        @client.response_handler(response)
        self
      end

      # Sets the storage pool
      # @param [Boolean] shareable
      # @param [String] provisionType 'Thin' or 'Full'
      # @param [String] capacity (in bytes)
      # @param [OneviewSDK::StoragePool] storage_pool
      def set_provisioning(shareable, provisionType, capacity, storage_pool)
        @data['provisioning']['shareable'] = shareable
        @data['provisioning']['provisionType'] = provisionType
        @data['provisioning']['capacity'] = capacity
        storage_pool.retrieve! unless storage_pool['uri']
        @data['provisioning']['storagePoolUri'] = storage_pool['uri']
      end

      # Sets the storage system
      # @param [OneviewSDK::StorageSystem] storage_system Storage System to be used to create the template
      def set_storage_system(storage_system)
        storage_system.retrieve! unless storage_system['uri']
        @data['storageSystemUri'] = storage_system['uri']
      end

      # Sets the snapshot pool
      # @param [OneviewSDK::StoragePool] storage_pool Storage Pool to generate the template
      def set_snapshot_pool(storage_pool)
        storage_pool.retrieve! unless storage_pool['uri']
        @data['snapshotPoolUri'] = storage_pool['uri']
      end

      # Gets the connectable volume templates by its attributes
      # @param [Hash] attributes Hash containing the attributes name and value
      def get_connectable_volume_templates(attributes = {})
        OneviewSDK::Resource.find_by(@client, attributes, BASE_URI + '/connectable-volume-templates')
      end
    end
  end
end
