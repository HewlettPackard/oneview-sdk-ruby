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

require_relative '../../api500/c7000/server_profile_template'

module OneviewSDK
  module API600
    module C7000
      # Server Profile Template resource implementation on API600 C7000
      class ServerProfileTemplate < OneviewSDK::API500::C7000::ServerProfileTemplate

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'ServerProfileTemplateV3'
          super
        end

        # Adds a connection entry to server profile template
        # @param [OneviewSDK::EthernetNetwork, OneviewSDK::FCNetwork] network Network associated with the connection
        # @param [Hash<String,String>] connection_options Hash containing the configuration of the connection
        # @option connection_options [Boolean] 'boot' Indicates that the server will attempt to boot from this connection.
        # @option connection_options [String] 'functionType' Type of function required for the connection. Values: Ethernet, FibreChannel, iSCSI.
        # @option connection_options [Integer] 'id' A unique identifier for this connection. If 0, id is automatically assigned.
        # @option connection_options [String] 'ipv4' The IP information for a connection. This is only used for iSCSI connections.
        # @option connection_options [String] 'name' Name of the connection.
        # @option connection_options [String] 'portId' Identifies the port (FlexNIC) used for this connection.
        # @option connection_options [String] 'requestedMbps' The transmit throughput (mbps) that should be allocated to this connection.
        # @option connection_options [String] 'requestedVFs' This value can be "Auto" or 0.
        def add_connection(network, connection_options = {})
          connection_options = Hash[connection_options.map { |k, v| [k.to_s, v] }]
          self['connectionSettings'] = {} unless self['connectionSettings']
          self['connectionSettings']['connections'] = [] unless self['connectionSettings']['connections']
          self['connectionSettings']['manageConnections'] = true
          connection_options['id'] ||= 0
          connection_options['networkUri'] = network['uri'] if network['uri'] || network.retrieve!
          self['connectionSettings']['connections'] << connection_options
        end

        # Removes a connection entry in server profile template
        # @param [String] connection_name Name of the connection
        # @return Returns the connection hash if found, otherwise returns nil
        def remove_connection(connection_name)
          desired_connection = nil
          return desired_connection unless self['connectionSettings']['connections']
          self['connectionSettings']['connections'].each do |con|
            desired_connection = self['connectionSettings']['connections'].delete(con) if con['name'] == connection_name
          end
          desired_connection
        end

        # Adds a volume attachment entry with new volume in Server profile template
        # @param [OneviewSDK::storage_pool] storage_pool Storage Pool Resource to add an attachment
        # @param [Hash] volume_options Options to create a new Volume.
        # @option volume_options [String] 'volumeName' The name of the volume.
        # @option volume_options [String] 'volumeDescription' The description of the storage volume.
        # @option volume_options [String] 'volumeProvisionType' The provisioning type of the new volume: Thin", "Full", or "Thin Deduplication".
        # @option volume_options [Integer] 'volumeProvisionedCapacityBytes' The requested provisioned capacity of the storage volume in bytes.
        # @param [Hash] attachment_options Options of the new attachment
        # @option attachment_options [String] 'associatedTemplateAttachmentId' Uniquely identifying of a volume attachment in a template.
        # @option attachment_options [String] 'dataProtectionLevel' Values specific to a StoreVirtual storage.
        # @option attachment_options [Integer] 'id' The ID of the storage volume attachment.
        # @option attachment_options [Boolean] 'isBootVolume' Identifies whether the volume will be used as a boot volume.
        # @option attachment_options [String] 'lun' Logical Unit Number.
        # @option attachment_options [String] 'lunType' Type of the LUN. Values: Manual or Auto.
        # @option attachment_options [Array] 'storagePaths' A list of host-to-target path associations.
        # @return Returns the connection hash if found, otherwise returns nil
        def create_volume_with_attachment(storage_pool, volume_options, attachment_options = {})
          raise IncompleteResource, 'Storage Pool not found!' unless storage_pool.retrieve!
          # Convert symbols keys to string in volume_options and attachment_options
          volume_options = Hash[volume_options.map { |k, v| [k.to_s, v] }]
          attachment_options = Hash[attachment_options.map { |k, v| [k.to_s, v] }]

          self['sanStorage'] ||= {}
          self['sanStorage']['volumeAttachments'] ||= []

          attachment_options['id'] ||= 0
          attachment_options['volumeStoragePoolUri'] = storage_pool['uri']
          attachment_options['volumeStorageSystemUri'] = storage_pool['storageSystemUri']
          attachment_options['volumeName'] = volume_options['name']
          attachment_options['volumeDescription'] = volume_options['description']
          attachment_options['volumeProvisionType'] = volume_options['provisioningType']
          attachment_options['volumeProvisionedCapacityBytes'] = volume_options['size']

          # Defaults
          attachment_options['volumeUri'] = nil
          attachment_options['permanent'] ||= true
          attachment_options['volumeShareable'] = false
          self['sanStorage']['manageSanStorage'] ||= true

          self['sanStorage']['volumeAttachments'] << attachment_options
        end
      end
    end
  end
end
