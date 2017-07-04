# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api300/c7000/volume'

module OneviewSDK
  module API500
    module C7000
      # Volume resource implementation on API500 C7000
      class Volume < OneviewSDK::API300::C7000::Volume

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available.
        def set_storage_system(*)
          unavailable_method
        end

        # Creates the volume
        # @note properties and templateUri parameters are required for creation, but not afterwards; after creation, they will be removed.
        # @raise [OneviewSDK::IncompleteResource] if the client is not set.
        # @raise [StandardError] if the resource creation fails.
        # @return [Resource] self
        def create
          properties = Hash[@data['properties'].map { |k, v| [k.to_sym, v] }]
          family = properties[:dataProtectionLevel].nil? ? 'StoreServ' : 'StoreVirtual'
          template_data = {
            isRoot: true,
            family: family
          }
          @data['templateUri'] = OneviewSDK::API500::C7000::VolumeTemplate.find_by(@client, template_data).first['uri'] unless @data['templateUri']
          OneviewSDK::Resource.instance_method(:create).bind(self).call
          @data.delete('properties')
          @data.delete('templateUri')
          self
        end

        # Deletes the resource from OneView or from Oneview and storage system
        # @param [Symbol] flag Delete storage system from Oneview only or in storage system as well.
        #   Flags: :all = removes the volume from oneview and storage system. :oneview = removes from oneview only.
        # @raise [InvalidResource] if an invalid flag is passed.
        # @return [true] if resource was deleted successfully.
        def delete(flag = :all)
          ensure_client && ensure_uri
          raise InvalidResource, 'Invalid flag value, use :oneview or :all' unless flag == :oneview || flag == :all
          uri = @data['uri']
          uri << '?suppressDeviceUpdates=true' if flag == :oneview
          response = @client.rest_delete(uri, 'If-Match' => @data['eTag'])
          @client.response_handler(response)
          true
        end

        # Sets the storage pool to the volume
        # @param [OneviewSDK::StoragePool] storage_pool Storage pool.
        def set_storage_pool(storage_pool)
          assure_uri(storage_pool)
          @data['properties'] ||= {}
          @data['properties']['storagePool'] = storage_pool['uri']
        end

        # Sets the snapshot pool to the volume
        # @param [OneviewSDK::StoragePool] storage_pool Storage Pool to use for snapshots.
        def set_snapshot_pool(storage_pool)
          assure_uri(storage_pool)
          @data['properties'] ||= {}
          @data['properties']['snapshotPool'] = storage_pool['uri']
        end

        # Creates a new volume on the storage system from a snapshot of a volume.
        # @note Volumes can only be created on storage pools managed by the appliance.
        # @param [String] snapshot_name The snapshot name.
        # @param [Hash] properties Storage Pool to use for snapshots.
        # @option properties [String] :provisioningType The provision type. Values: Full or Thin.
        # @option properties [String] :name The name for new volume.
        # @option properties [String] :isShareable Indicates whether or not the volume can be shared by multiple profiles.
        # @param [OneviewSDK::VolumeTemplate] volume_template The Volume Template resource.
        # @param [Boolean] is_permanent If true, indicates that the volume will persist when the profile using this volume is deleted.
        # @raise [IncompleteResource] if the snapshot or volume template are not found.
        # @return [OneviewSDK::Volume] The volume created.
        def create_from_snapshot(snapshot_name, properties, volume_template = nil, is_permanent = true)
          snapshot = get_snapshot(snapshot_name)
          raise IncompleteResource, 'Snapshot not found!' unless snapshot
          storage_pool_uri = nil
          volume_template = if volume_template.nil?
                              storage_pool_uri = @data['storagePoolUri']
                              OneviewSDK::API500::C7000::VolumeTemplate.find_by(@client, isRoot: true, family: 'StoreServ').first
                            else
                              raise IncompleteResource, 'Volume Template not found!' unless volume_template.retrieve!
                              storage_pool_uri = volume_template['storagePoolUri']
                              volume_template
                            end

          data = {
            'properties' => properties.merge('storagePool' => storage_pool_uri, 'snapshotPool' => storage_pool_uri),
            'snapshotUri' => snapshot['uri'],
            'templateUri' => volume_template['uri'],
            'isPermanent' => is_permanent
          }

          response = @client.rest_post("#{BASE_URI}/from-snapshot", 'body' => data)
          self.class.new(@client, client.response_handler(response))
        end

        # Initiates a process to import a volume (created external to OneView) for management by the appliance.
        # @note Volumes can be added only on the storage system and storage pools managed by the appliance.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance.
        # @param [OneviewSDK::StorageSystem] storage_system The storage system in which the volume exists to be managed.
        # @param [String] volume_name The name of the volume on the actual storage system.
        # @param [Boolean] is_shareable Describes if the volume is shareable or private.
        # @param [Hash] options The options to create a volume.
        # @option options [String] :name The name for new volume.
        # @option options [String] :description The description for new volume.
        # @raise [OneviewSDK::IncompleteResource] if storage system is not found
        # @return [OneviewSDK::Volume] The volume imported.
        def self.add(client, storage_system, volume_name, is_shareable = false, options = {})
          raise IncompleteResource, 'Storage system not found!' unless storage_system.retrieve!
          data = options.merge('storageSystemUri' => storage_system['uri'], 'deviceVolumeName' => volume_name, 'isShareable' => is_shareable)
          response = client.rest_post("#{BASE_URI}/from-existing", 'body' => data)
          new(client, client.response_handler(response))
        end

        private

        # Sets the snapshot data
        # @param [String] name The name of the snapshot
        # @param [String] description The description of the snapshot
        # @return [Hash] snapshot data
        def generate_snapshot_data(name, description = nil)
          { description: description, name: name }
        end
      end
    end
  end
end
