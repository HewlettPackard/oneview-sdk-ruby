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
require_relative '../../resource_helper'

module OneviewSDK
  module API200
    # Server profile resource implementation
    class ServerProfile < Resource
      include OneviewSDK::ResourceHelper
      BASE_URI = '/rest/server-profiles'.freeze
      UNIQUE_IDENTIFIERS = %w(name uri associatedServer serialNumber serverHardwareUri).freeze

      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values
        @data['type'] ||= 'ServerProfileV5'
      end

      # Sets the Server Hardware for the resource
      # @param [OneviewSDK::ServerHardware] server_hardware Server Hardware resource
      # @raise [OneviewSDK::IncompleteResource] if server hardware not found
      def set_server_hardware(server_hardware)
        raise 'Server Hardware could not be found!' unless server_hardware.retrieve!
        self['serverHardwareUri'] = server_hardware['uri']
      end

      # Sets the Server Hardware Type for the resource
      # @param [OneviewSDK::ServerHardwareType] server_hardware_type Type of the desired Server Hardware
      # @raise [OneviewSDK::IncompleteResource] if server hardware type not found
      def set_server_hardware_type(server_hardware_type)
        raise 'Server Hardware Type could not be found!' unless server_hardware_type.retrieve!
        self['serverHardwareTypeUri'] = server_hardware_type['uri']
      end

      # Sets the Enclosure Group for the resource
      # @param [OneviewSDK::EnclosureGroup] enclosure_group Enclosure Group that the Server is a member
      # @raise [OneviewSDK::IncompleteResource] if enclosure group not found
      def set_enclosure_group(enclosure_group)
        raise 'Enclosure Group could not be found!' unless enclosure_group.retrieve!
        self['enclosureGroupUri'] = enclosure_group['uri']
      end

      # Sets the Enclosure for the resource
      # @param [OneviewSDK::Enclosure] enclosure Enclosure that the Server is a member
      # @raise [OneviewSDK::IncompleteResource] if enclosure not found
      def set_enclosure(enclosure)
        raise 'Enclosure could not be found!' unless enclosure.retrieve!
        self['enclosureUri'] = enclosure['uri']
      end

      # Gets the preview of manual and automatic updates required to make the server profile consistent with its template.
      # @return [Hash] Hash containing the required information
      def get_compliance_preview
        ensure_client & ensure_uri
        response = @client.rest_get("#{self['uri']}/compliance-preview")
        @client.response_handler(response)
      end

      # Retrieves the error or status messages associated with the specified profile.
      # @return [Hash] Hash containing the required information
      def get_messages
        ensure_client & ensure_uri
        response = @client.rest_get("#{self['uri']}/messages")
        @client.response_handler(response)
      end

      # Transforms an existing profile by supplying a new server hardware type and/or enclosure group.
      #   A profile will be returned with a new configuration based on the capabilities of the supplied
      #   server hardware type and/or enclosure group. All deployed connections will have their port assignment
      #   set to 'Auto'. Re-selection of the server hardware may also be required. The new profile can subsequently
      #   be used for the PUT https://{appl}/rest/server- profiles/{id} API but is not guaranteed to pass
      #   validation. Any incompatibilities will be flagged when the transformed server profile is submitted.
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
      # @option query [OneviewSDK::ServerHardware] 'server_hardware' The server hardware associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      # @return [Hash] Hash containing the required information
      def get_transformation(query = nil)
        ensure_client & ensure_uri
        query_uri = OneviewSDK::Resource.build_query(query) if query
        response = @client.rest_get("#{self['uri']}/transformation#{query_uri}")
        @client.response_handler(response)
      end

      # Updates the server profile from the server profile template.
      def update_from_template
        patch('replace', '/templateCompliance', 'Compliant', 'If-Match' => self['eTag'])
      end

      # @!group Helpers

      # Gets attached ServerHardware for the profile
      # @return [OneviewSDK::ServerHardware] if hardware is attached
      # @return [nil] if no hardware is attached
      def get_server_hardware
        return nil unless self['serverHardwareUri']
        sh = OneviewSDK::ServerHardware.new(@client, uri: self['serverHardwareUri'])
        sh.retrieve!
        sh
      end

      # Gets all the available Ethernet and FC Networks, and Network Sets
      # @return [Hash]
      #   A hash containing the lists of Ethernet Networks and FC Networks
      def get_available_networks
        query = { enclosure_group_uri: @data['enclosureGroupUri'], server_hardware_type_uri: @data['serverHardwareTypeUri'] }
        self.class.get_available_networks(@client, query)
      end

      # Gets available server hardware
      # @return [Array<OneviewSDK::ServerHardware>] Array of ServerHardware resources that matches this
      #   profile's server hardware type and enclosure group and who's state is 'NoProfileApplied'
      def get_available_hardware
        ensure_client
        raise IncompleteResource, 'Must set @data[\'serverHardwareTypeUri\']' unless @data['serverHardwareTypeUri']
        raise IncompleteResource, 'Must set @data[\'enclosureGroupUri\']' unless @data['enclosureGroupUri']
        params = {
          state: 'NoProfileApplied',
          serverHardwareTypeUri: @data['serverHardwareTypeUri'],
          serverGroupUri: @data['enclosureGroupUri']
        }
        variant = self.class.name.split('::').at(-2)
        OneviewSDK.resource_named('ServerHardware', @client.api_version, variant).find_by(@client, params)
      rescue StandardError => e
        raise IncompleteResource, "Failed to get available hardware. Message: #{e.message}"
      end

      # Adds a connection entry to Server profile template
      # @param [OneviewSDK::EthernetNetwork,OneviewSDK::FCNetwork] network Network associated with the connection
      # @param [Hash<String,String>] connection_options Hash containing the configuration of the connection
      # @option connection_options [Integer] 'allocatedMbps' The transmit throughput (mbps) currently allocated to
      #   this connection. When Fibre Channel connections are set to Auto for requested bandwidth, the value can be set to -2000
      #   to indicate that the actual value is unknown until OneView is able to negotiate the actual speed.
      # @option connection_options [Integer] 'allocatedVFs' The number of virtual functions allocated to this connection. This value will be null.
      # @option connection_options [Hash] 'boot' indicates that the server will attempt to boot from this connection.
      #   This object can only be specified if "boot.manageBoot" is set to 'true'
      # @option connection_options [String] 'deploymentStatus' The deployment status of the connection.
      #   The value can be 'Undefined', 'Reserved', or 'Deployed'.
      # @option connection_options [String] 'functionType' Type of function required for the connection.
      #   functionType cannot be modified after the connection is created.
      # @option connection_options [String] 'id' Unique identifier for this connection. Defaults to 0 (auto).
      # @option connection_options [String] 'mac' The MAC address that is currently programmed on the FlexNic.
      # @option connection_options [String] 'macType' Specifies the type of MAC address to be programmed into the IO Devices.
      #   The value can be 'Virtual', 'Physical' or 'UserDefined'.
      # @option connection_options [String] 'maximumMbps' Maximum transmit throughput (mbps) allowed on this connection.
      #   The value is limited by the maximum throughput of the network link and maximumBandwidth of the selected network (networkUri).
      #   For Fibre Channel connections, the value is limited to the same value as the allocatedMbps.
      # @option connection_options [String] 'name' A string used to identify the respective connection.
      #   The connection name is case insensitive, limited to 63 characters and must be unique within the profile.
      # @option connection_options [String] 'portId' Identifies the port (FlexNIC) used for this connection.
      # @option connection_options [String] 'requestedMbps' The transmit throughput (mbps) that should be allocated to this connection.
      # @option connection_options [String] 'requestedVFs' This value can be "Auto" or 0.
      # @option connection_options [String] 'wwnn' The node WWN address that is currently programmed on the FlexNic.
      # @option connection_options [String] 'wwpn' The port WWN address that is currently programmed on the FlexNic.
      # @option connection_options [String] 'wwpnType' Specifies the type of WWN address to be porgrammed on the FlexNIC.
      #   The value can be 'Virtual', 'Physical' or 'UserDefined'.
      def add_connection(network, connection_options = {})
        connection_options = Hash[connection_options.map { |k, v| [k.to_s, v] }]
        self['connections'] = [] unless self['connections']
        connection_options['id'] ||= 0
        connection_options['networkUri'] = network['uri'] if network['uri'] || network.retrieve!
        self['connections'] << connection_options
      end

      # Removes a connection entry in Server profile template
      # @param [String] connection_name Name of the connection
      # @return Returns the connection hash if found, otherwise returns nil
      def remove_connection(connection_name)
        desired_connection = nil
        return desired_connection unless self['connections']
        self['connections'].each do |con|
          desired_connection = self['connections'].delete(con) if con['name'] == connection_name
        end
        desired_connection
      end

      # Adds volume attachment entry with associated Volume in Server profile
      # @param [OneviewSDK::Volume] volume Volume Resource to add an attachment
      # @param [Hash] attachment_options Options of the new attachment
      # @option attachment_options [Fixnum] 'id' The ID of the attached storage volume. Do not use it if you want it to be created automatically.
      # @option attachment_options [String] 'lun' The logical unit number.
      # @option attachment_options [String] 'lunType' The logical unit number type: Auto or Manual.
      # @option attachment_options [Boolean] 'permanent' Required. If true, indicates that the volume will persist when the profile is deleted.
      #   If false, then the volume will be deleted when the profile is deleted.
      # @option attachment_options [Array] 'storagePaths' A list of host-to-target path associations.
      # @raise [OneviewSDK::IncompleteResource] if volume not found
      # @return Returns the connection hash if found, otherwise returns nil
      def add_volume_attachment(volume, attachment_options = {})
        raise IncompleteResource, 'Volume not found!' unless volume.retrieve!
        # Convert symbols keys to string
        attachment_options = Hash[attachment_options.map { |k, v| [k.to_s, v] }]
        self['sanStorage'] ||= {}
        self['sanStorage']['volumeAttachments'] ||= []
        self['sanStorage']['manageSanStorage'] ||= true
        attachment_options['id'] ||= 0
        attachment_options['volumeUri'] = volume['uri']
        attachment_options['volumeStoragePoolUri'] = volume['storagePoolUri']
        attachment_options['volumeStorageSystemUri'] = volume['storageSystemUri']

        self['sanStorage']['volumeAttachments'] << attachment_options
      end

      # Adds volume attachment entry and creates a new Volume associated in the Server profile
      # @param [OneviewSDK::StoragePool] storage_pool StoragePool Resource to add an attachment
      # @param [Hash] volume_options Options to create a new Volume.
      #   Please refer to OneviewSDK::Volume documentation for the data necessary to create a new Volume.
      # @param [Hash] attachment_options Options of the new attachment
      # @option attachment_options [Fixnum] 'id' The ID of the attached storage volume. Do not use it if you want it to be created automatically.
      # @option attachment_options [String] 'lun' The logical unit number.
      # @option attachment_options [String] 'lunType' The logical unit number type: Auto or Manual.
      # @option attachment_options [Boolean] 'permanent' Required. If true, indicates that the volume will persist when the profile is deleted.
      #   If false, then the volume will be deleted when the profile is deleted.
      # @option attachment_options [Array] 'storagePaths' A list of host-to-target path associations.
      # @raise [OneviewSDK::IncompleteResource] if storage pool not found
      # @return Returns the connection hash if found, otherwise returns nil
      def create_volume_with_attachment(storage_pool, volume_options, attachment_options = {})
        raise IncompleteResource, 'Storage Pool not found!' unless storage_pool.retrieve!
        # Convert symbols keys to string in volume_options and attachment_options
        volume_options = Hash[volume_options.map { |k, v| [k.to_s, v] }]
        attachment_options = Hash[attachment_options.map { |k, v| [k.to_s, v] }]
        self['sanStorage'] ||= {}
        self['sanStorage']['volumeAttachments'] ||= []
        attachment_options['id'] ||= 0
        # Removing provisioningParameters and adding them to the top level hash
        provision_param = volume_options.delete('provisioningParameters') || volume_options.delete(:provisioningParameters)
        provision_param.each do |k, v|
          volume_options[k] = v
        end
        # Each provisioningParameter has the prefix 'volume' attached to its name in the original options
        # Also, it needs to respect the lower camel case
        volume_options.each do |k, v|
          attachment_options["volume#{k.to_s[0].capitalize}#{k.to_s[1, k.to_s.length - 1]}"] = v
        end

        attachment_options['volumeStoragePoolUri'] = storage_pool['uri']

        # Since the volume is being created in this method, it needs to be nil
        attachment_options['volumeUri'] = nil
        attachment_options['volumeStorageSystemUri'] = nil

        # volumeProvisionedCapacityBytes is not following the same pattern in Volume
        attachment_options['volumeProvisionedCapacityBytes'] ||= attachment_options.delete('volumeRequestedCapacity')

        # Defaults
        attachment_options['permanent'] ||= true
        attachment_options['lunType'] ||= 'Auto'
        attachment_options['lun'] ||= nil
        attachment_options['storagePaths'] ||= []
        attachment_options['volumeShareable'] = false

        self['sanStorage']['manageSanStorage'] ||= true
        self['sanStorage']['volumeAttachments'] << attachment_options
      end

      # Removes a volume attachment entry in the Server profile
      # @param [Fixnum] id ID number of the attachment entry
      # @return Returns the volume hash if found, otherwise returns nil
      def remove_volume_attachment(id)
        self['sanStorage'] ||= {}
        self['sanStorage']['volumeAttachments'] ||= []
        return if self['sanStorage'].empty? || self['sanStorage']['volumeAttachments'].empty?

        volume_attachment = nil
        self['sanStorage']['volumeAttachments'].each do |entry|
          volume_attachment = self['sanStorage']['volumeAttachments'].delete(entry) if entry['id'] == id
        end
        volume_attachment
      end

      # Sets the Firmware Driver for the server profile
      # @param [OneviewSDK::FirmwareDriver] firmware Firmware Driver to be associated with the resource
      # @param [Hash<String,Object>] firmware_options Firmware Driver options
      # @option firmware_options [Boolean] 'manageFirmware' Indicates that the server firmware is configured using the server profile.
      #   Value can be 'true' or 'false'.
      # @option firmware_options [Boolean] 'forceInstallFirmware' Force installation of firmware even if same or newer version is installed.
      #   Downgrading the firmware can result in the installation of unsupported firmware and cause server hardware to cease operation.
      #   Value can be 'true' or 'false'.
      # @option firmware_options [String] 'firmwareInstallType' Specifies the way a Service Pack for ProLiant (SPP) is installed.
      #   This field is used if the 'manageFirmware' field is true.
      #   Values are 'FirmwareAndOSDrivers', 'FirmwareOnly', and 'FirmwareOnlyOfflineMode'.
      def set_firmware_driver(firmware, firmware_options = {})
        firmware_options['firmwareBaselineUri'] = firmware['uri'] if firmware['uri'] || firmware.retrieve!
        self['firmware'] = firmware_options
      end

      # @!endgroup

      # Gets all the available ethernet and fc networks, and network sets
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
      # @option query [String] 'function_type' The FunctionType (Ethernet or FibreChannel) to filter the list of networks returned
      # @option query [OneviewSDK::ServerHardware] 'server_hardware' The server hardware associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      # @option query [String] 'view' Name of a predefined view to return a specific subset of the attributes of the resource or collection
      # @return [Hash]
      #   A hash containing the lists of Ethernet and FC Networks, and Network Sets
      #   Options:
      #     * [String] 'ethernetNetworks' The list of Ethernet Networks
      #     * [String] 'fcNetworks' The list of FC Networks
      #     * [String] 'networkSets' The list of Networks Sets
      def self.get_available_networks(client, query)
        query_uri = build_query(query) if query
        response = client.rest_get("#{BASE_URI}/available-networks#{query_uri}")
        body = client.response_handler(response)
        body.select { |k, _v| %w(ethernetNetworks networkSets fcNetworks).include?(k) }
      end

      # Gets the available servers based on the query parameters
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
      # @option query [OneviewSDK::ServerProfile] 'server_profile' The server profile associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      # @return [Hash] Hash containing all the available server information
      def self.get_available_servers(client, query = nil)
        if query
          query_uri = build_query(query)
          # profileUri attribute is not following the standards in OneView
          query_uri.sub!('serverProfileUri', 'profileUri')
        end
        response = client.rest_get("#{BASE_URI}/available-servers#{query_uri}")
        client.response_handler(response)
      end

      # Gets the available storage systems based on the query parameters
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      # @option query [OneviewSDK::StorageSystem] 'storage_system' The Storage System the resources are associated with
      def self.get_available_storage_system(client, query = nil)
        # For storage_system the query requires the ID instead the URI
        if query && query['storage_system']
          query['storage_system'].retrieve! unless query['storage_system']['uri']
          query['storage_system_id'] = query['storage_system']['uri'].split('/').last
          query.delete('storage_system')
        end
        query_uri = build_query(query) if query
        response = client.rest_get("#{BASE_URI}/available-storage-system#{query_uri}")
        client.response_handler(response)
      end

      # Gets the available storage systems based on the query parameters
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' The enclosure group associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      # @option query [Array<String>] 'filter' A general filter/query string to narrow the list of items returned.
      #   The default is no filter - all resources are returned.
      # @option query [Integer] 'start' The first item to return, using 0-based indexing.
      #   If not specified, the default is 0 - start with the first available item.
      # @option query [Integer] 'count' The sort order of the returned data set.
      #   By default, the sort order is based on create time, with the oldest entry first.
      # @option query [String] 'sort' The number of resources to return. A count of -1 requests all the items.
      def self.get_available_storage_systems(client, query = nil)
        query_uri = build_query(query) if query
        find_with_pagination(client, "#{BASE_URI}/available-storage-systems#{query_uri}")
      end

      # Get the available targets based on the query parameters
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
      # @option query [OneviewSDK::ServerProfile] 'server_profile' The server profile associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      def self.get_available_targets(client, query = nil)
        query_uri = build_query(query) if query
        response = client.rest_get("#{BASE_URI}/available-targets#{query_uri}")
        client.response_handler(response)
      end

      # Gets all the available ethernet and fc networks
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash<String,Object>] query Query parameters
      # @option query [OneviewSDK::EnclosureGroup] 'enclosure_group' Enclosure Group associated with the resource
      # @option query [OneviewSDK::ServerHardware] 'server_hardware' The server hardware associated with the resource
      # @option query [OneviewSDK::ServerHardwareType] 'server_hardware_type' The server hardware type associated with the resource
      def self.get_profile_ports(client, query = nil)
        query_uri = build_query(query) if query
        response = client.rest_get("#{BASE_URI}/profile-ports#{query_uri}")
        client.response_handler(response)
      end
    end
  end
end
