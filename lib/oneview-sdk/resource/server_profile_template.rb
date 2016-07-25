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
  # Server profile template resource implementation
  class ServerProfileTemplate < Resource
    BASE_URI = '/rest/server-profile-templates'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'ServerProfileTemplateV1'
    end

    # Sets the Server Hardware Type for the Server Profile Template
    # @param [OneviewSDK::ServerHardwareType] server_hardware_type Type of the desired Server Hardware
    def set_server_hardware_type(server_hardware_type)
      self['serverHardwareTypeUri'] = server_hardware_type['uri'] if server_hardware_type['uri'] || server_hardware_type.retrieve!
      fail "Resource #{server_hardware_type['name']} could not be found!" unless server_hardware_type['uri']
    end

    # Sets the Enclosure Group for the Server Profile Template
    # @param [OneviewSDK::EnclosureGroup] enclosure_group Enclosure Group that the Server is a member
    def set_enclosure_group(enclosure_group)
      self['enclosureGroupUri'] = enclosure_group['uri'] if enclosure_group['uri'] || enclosure_group.retrieve!
      fail "Resource #{enclosure_group['name']} could not be found!" unless enclosure_group['uri']
    end

    # Sets the Firmware Driver for the current Server Profile Template
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

    # Add connection entry to Server profile template
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
      self['connections'] = [] unless self['connections']
      connection_options['id'] = 0 # Letting OneView treat the ID registering
      connection_options['networkUri'] = network['uri'] if network['uri'] || network.retrieve!
      self['connections'] << connection_options
    end

    # Remove connection entry in Server profile template
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

    # Adds volume attachment entry with associated Volume in Server profile template
    # @param [OneviewSDK::Volume] volume Volume Resource to add an attachment
    # @param [Hash] attachment_options Options of the new attachment
    # @option attachment_options [Fixnum] 'id' The ID of the attached storage volume. Do not use it if you want it to be created automatically.
    # @option attachment_options [String] 'lun' The logical unit number.
    # @option attachment_options [String] 'lunType' The logical unit number type: Auto or Manual.
    # @option attachment_options [Boolean] 'permanent' Required. If true, indicates that the volume will persist when the profile is deleted.
    #   If false, then the volume will be deleted when the profile is deleted.
    # @option attachment_options [Array] 'storagePaths' A list of host-to-target path associations.
    # @return Returns the connection hash if found, otherwise returns nil
    def add_volume_attachment(volume, attachment_options = {})
      self['sanStorage'] ||= {}
      self['sanStorage']['volumeAttachments'] ||= []
      attachment_options['id'] ||= 0

      volume.retrieve! unless volume['uri'] || volume['storagePoolUri'] || volume['storageSystemUri']
      attachment_options['volumeUri'] = volume['uri']
      attachment_options['volumeStoragePoolUri'] = volume['storagePoolUri']
      attachment_options['volumeStorageSystemUri'] = volume['storageSystemUri']

      self['sanStorage']['volumeAttachments'] << attachment_options
    end

    # Add volume attachment entry with new volume in Server profile template
    # @param [OneviewSDK::Volume] volume Volume Resource to add an attachment
    # @param [Hash] volume_options Options to create a new Volume.
    #   Please refer to OneviewSDK::Volume documentation for the data necessary to create a new Volume.
    # @param [Hash] attachment_options Options of the new attachment
    # @option attachment_options [Fixnum] 'id' The ID of the attached storage volume. Do not use it if you want it to be created automatically.
    # @option attachment_options [String] 'lun' The logical unit number.
    # @option attachment_options [String] 'lunType' The logical unit number type: Auto or Manual.
    # @option attachment_options [Boolean] 'permanent' Required. If true, indicates that the volume will persist when the profile is deleted.
    #   If false, then the volume will be deleted when the profile is deleted.
    # @option attachment_options [Array] 'storagePaths' A list of host-to-target path associations.
    # @return Returns the connection hash if found, otherwise returns nil
    def create_volume_with_attachment(storage_pool, volume_options, attachment_options = {})
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

      attachment_options['volumeStoragePoolUri'] = storage_pool['uri'] if storage_pool['uri'] || storage_pool.retrieve!

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

      self['sanStorage']['volumeAttachments'] << attachment_options
    end

    # Remove volume attachment entry in Server profile template
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

    # Get available server hardware
    # @return [Array<OneviewSDK::ServerHardware>] Array of ServerHardware resources that matches this
    #   profile template's server hardware type and enclosure group and who's state is 'NoProfileApplied'
    def available_hardware
      ensure_client
      fail IncompleteResource, 'Must set @data[\'serverHardwareTypeUri\']' unless @data['serverHardwareTypeUri']
      fail IncompleteResource, 'Must set @data[\'enclosureGroupUri\']' unless @data['enclosureGroupUri']
      params = {
        state: 'NoProfileApplied',
        serverHardwareTypeUri: @data['serverHardwareTypeUri'],
        serverGroupUri: @data['enclosureGroupUri']
      }
      OneviewSDK::ServerHardware.find_by(@client, params)
    rescue StandardError => e
      raise IncompleteResource, "Failed to get available hardware. Message: #{e.message}"
    end

    # Create ServerProfile using this template
    # @param [String] name Name of new server profile
    # @return [OneviewSDK::ServerProfile] New server profile from template.
    #   Temporary object only; call .create to actually create resource on OneView.
    def new_profile(name = nil)
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/new-profile")
      options = @client.response_handler(response)
      profile = OneviewSDK::ServerProfile.new(@client, options)
      profile['name'] = name ? name : "Server_Profile_created_from_#{@data['name']}"
      profile
    end
  end
end
