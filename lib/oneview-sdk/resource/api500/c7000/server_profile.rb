# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api300/c7000/server_profile'

module OneviewSDK
  module API500
    module C7000
      # Server Profile resource implementation on API500 C7000
      class ServerProfile < OneviewSDK::API300::C7000::ServerProfile

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interacting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'ServerProfileV7'
          super
        end

        # Adds volume attachment entry and creates a new Volume associated in the Server profile
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
          attachment_options['permanent'] ||= true
          attachment_options['lunType'] ||= 'Auto'
          attachment_options['lun'] ||= nil
          attachment_options['storagePaths'] ||= []
          attachment_options['volumeShareable'] = false

          self['sanStorage']['manageSanStorage'] ||= true
          self['sanStorage']['volumeAttachments'] << attachment_options
        end

        # Retrieves the profile template for a given server profile.
        # @return Returns a ServerProfileTemplate instance
        def get_profile_template
          response = @client.rest_get("#{@data['uri']}/new-profile-template")
          variant = self.class.name.split('::').at(-2)
          OneviewSDK.resource_named('ServerProfileTemplate', @client.api_version, variant).new(client, @client.response_handler(response))
        end
      end
    end
  end
end
