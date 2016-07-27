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
    # @raise [OneviewSDK::IncompleteResource] if the client is not set
    # @raise [StandardError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'body' => @data }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      @data.delete('provisioningParameters')
      self
    end

    # Deletes the resource from OneView or from Oneview and storage system
    # @param [Symbol] flag Delete storage system from Oneview only or in storage system as well
    # @return [true] if resource was deleted successfully
    def delete(flag = :all)
      ensure_client && ensure_uri
      case flag
      when :oneview
        response = @client.rest_api(:delete, @data['uri'], { 'exportOnly' => true }, @api_version)
        @client.response_handler(response)
      when :all
        response = @client.rest_api(:delete, @data['uri'], {}, @api_version)
        @client.response_handler(response)
      else
        fail InvalidResource, 'Invalid flag value, use :oneview or :all'
      end
      true
    end

    # Sets the storage system to the volume
    # @param [OneviewSDK::StorageSystem] storage_system Storage System
    def set_storage_system(storage_system)
      assure_uri(storage_system)
      set('storageSystemUri', storage_system['uri'])
    end

    # Sets the storage pool to the volume
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
      data = {
        type: 'Snapshot',
        description: description,
        name: name
      }
      response = @client.rest_post("#{@data['uri']}/snapshots", { 'body' => data }, @api_version)
      @client.response_handler(response)
      true
    end

    # Deletes a snapshot of the volume
    # @param [String] name snapshot name
    # @return [true] if snapshot was created successfully
    def delete_snapshot(name)
      result = get_snapshot(name)
      response = @client.rest_api(:delete, result['uri'], {}, @api_version)
      @client.response_handler(response)
      true
    end

    # Retrieves a snapshot by name
    # @param [String] name
    # @return [Hash] snapshot data
    def get_snapshot(name)
      results = get_snapshots
      results.each do |snapshot|
        return snapshot if snapshot['name'] == name
      end
    end

    # Gets all the snapshots of this volume
    # @return [Array] Array of snapshots
    def get_snapshots
      ensure_uri && ensure_client
      results = []
      uri = "#{@data['uri']}/snapshots"
      loop do
        response = @client.rest_get(uri, @api_version)
        body = @client.response_handler(response)
        members = body['members']
        members.each do |member|
          results.push(member)
        end
        break unless body['nextPageUri']
        uri = body['nextPageUri']
      end
      results
    end

    # Gets all the attachable volumes managed by the appliance
    # @param [Client] client The client object for the appliance
    # @return [Array<OneviewSDK::Volume>] Array of volumes
    def self.get_attachable_volumes(client)
      results = []
      uri = "#{BASE_URI}/attachable-volumes"
      loop do
        response = client.rest_get(uri)
        body = client.response_handler(response)
        members = body['members']
        members.each { |member| results.push(OneviewSDK::Volume.new(client, member)) }
        break unless body['nextPageUri']
        uri = body['nextPageUri']
      end
      results
    end

    # Gets the list of extra managed storage volume paths
    # @param [OneviewSDK::Client] client
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
    def assure_uri(resource)
      resource.retrieve! unless resource['uri']
      fail IncompleteResource, "#{resource.class}: #{resource['name']} not found" unless resource['uri']
    end
  end
end
