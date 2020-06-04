# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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
    # Volume resource implementation
    class Volume < Resource
      BASE_URI = '/rest/storage-volumes'.freeze

      # It's possible to create the volume in 6 different ways:
      # 1) Common = Storage System + Storage Pool
      # 2) Template = Storage Volume Template
      # 3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool
      # 4) Management = Storage System + wwn
      # 5) Management by name = Storage System + Storage System Volume Name
      # 6) Snapshot = Snapshot Pool + Storage Pool + Snapshot

      # Creates the volume
      # @note provisioning parameters are required for creation, but not afterwards; after creation, they will be removed.
      # @param [Hash] header The header options for the request (key-value pairs)
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create(header = {})
        super(DEFAULT_REQUEST_HEADER.merge(header))
        @data.delete('provisioningParameters')
        self
      end

      # Delete the resource from OneView if it exists, then create it using the current data
      # @note Calls refresh method to set additional data
      # @param [Hash] header The header options for the request (key-value pairs)
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create!(header = {})
        temp = self.class.new(@client, @data)
        header = DEFAULT_REQUEST_HEADER.merge(header)
        temp.delete(:all, header) if temp.retrieve!(header)
        create(header)
      end

      # Update resource attributes
      # @param [Hash] attributes attributes to be updated
      # @return [OneviewSDK::Volume] self
      def update(attributes = {})
        @data.delete('provisioningParameters')
        super
      end

      # Deletes the resource from OneView or from Oneview and storage system
      # @param [Symbol] flag Delete storage system from Oneview only or in storage system as well
      # @param [Hash] header The header options for the request (key-value pairs)
      # @return [true] if resource was deleted successfully
      def delete(flag = :all, header = {})
        ensure_client && ensure_uri
        raise InvalidResource, 'Invalid flag value, use :oneview or :all' unless %i[oneview all].include?(flag)
        header = DEFAULT_REQUEST_HEADER.merge(header).merge('exportOnly' => true) if flag == :oneview
        super(header)
      end

      # Sets the storage system to the volume
      # @param [OneviewSDK::StorageSystem] storage_system Storage System
      # @note The storageSystemUri attribute should not be set in the updated. Once created, this attribute is read only.
      def set_storage_system(storage_system)
        assure_uri(storage_system)
        set('storageSystemUri', storage_system['uri'])
      end

      # Sets the storage pool to the volume
      # @note The storagePoolUri attribute should not be set in the updated. Once created, this attribute is read only.
      # @param [OneviewSDK::StoragePool] storage_pool Storage pool
      def set_storage_pool(storage_pool)
        assure_uri(storage_pool)
        self['provisioningParameters'] ||= {}
        self['provisioningParameters']['storagePoolUri'] = storage_pool['uri']
      end

      # Adds the storage volume template to the volume
      # @param [OneviewSDK::VolumeTemplate] storage_volume_template Storage Volume Template
      def set_storage_volume_template(storage_volume_template)
        assure_uri(storage_volume_template)
        set('templateUri', storage_volume_template['uri'])
      end

      # Sets the snapshot pool to the volume
      # @param [OneviewSDK::StoragePool] storage_pool Storage Pool to use for snapshots
      def set_snapshot_pool(storage_pool)
        assure_uri(storage_pool)
        set('snapshotPoolUri', storage_pool['uri'])
      end

      # Creates a snapshot of the volume
      # @param [String, OneviewSDK::VolumeSnapshot] snapshot String or OneviewSDK::VolumeSnapshot object
      # @param [String] description Provide a description
      # @return [true] if snapshot was created successfully
      def create_snapshot(snapshot, description = nil)
        ensure_uri && ensure_client
        if snapshot.is_a?(OneviewSDK::Resource) || snapshot.is_a?(Hash)
          name = snapshot[:name] || snapshot['name']
          description ||= snapshot[:description] || snapshot['description']
        else
          name = snapshot
        end
        data = generate_snapshot_data(name, description)
        response = @client.rest_post("#{@data['uri']}/snapshots", { 'body' => data }, @api_version)
        @client.response_handler(response)
        true
      end

      # Deletes a snapshot of the volume
      # @param [String] name snapshot name
      # @return [true] if snapshot was created successfully
      def delete_snapshot(name)
        result = get_snapshot(name)
        response = @client.rest_delete(result['uri'], { 'If-Match' => result['eTag'] }, @api_version)
        @client.response_handler(response)
        true
      end

      # Retrieves a snapshot by name
      # @param [String] name
      # @return [Hash] snapshot data
      def get_snapshot(name)
        results = get_snapshots
        results.find { |snap| snap['name'] == name }
      end

      # Gets all the snapshots of this volume
      # @return [Array] Array of snapshots
      def get_snapshots
        ensure_uri && ensure_client
        uri = "#{@data['uri']}/snapshots"
        self.class.find_with_pagination(@client, uri)
      end

      # Gets all the attachable volumes managed by the appliance
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @return [Array<OneviewSDK::Volume>] Array of volumes
      def self.get_attachable_volumes(client, query = nil)
        query_uri = build_query(query) if query
        uri = "#{BASE_URI}/attachable-volumes#{query_uri}"
        find_by(client, {}, uri)
      end

      # Gets the list of extra managed storage volume paths
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @return response
      def self.get_extra_managed_volume_paths(client)
        response = client.rest_get(BASE_URI + '/repair?alertFixType=ExtraManagedStorageVolumePaths')
        client.response_handler(response)
      end

      # Removes extra presentation from the volume
      # @return response
      def repair
        response = client.rest_post(BASE_URI + '/repair', 'body' => { resourceUri: @data['uri'], type: 'ExtraManagedStorageVolumePaths' })
        client.response_handler(response)
      end

      private

      # Verify if the resource has a URI
      # If not, first it tries to retrieve, and then verify for its existence
      # @param [OneviewSDK::Resource] resource The resource object
      # @raise [OneviewSDK::IncompleteResource] if the resource not found
      def assure_uri(resource)
        resource.retrieve! unless resource['uri']
        raise IncompleteResource, "#{resource.class}: #{resource['name']} not found" unless resource['uri']
      end

      # Generates the snapshot data
      # @param [String] name The name of the snapshot
      # @param [String] description The description of the snapshot
      # @return [Hash] snapshot data
      def generate_snapshot_data(name, description = nil)
        { type: 'Snapshot', description: description, name: name }
      end
    end
  end
end
