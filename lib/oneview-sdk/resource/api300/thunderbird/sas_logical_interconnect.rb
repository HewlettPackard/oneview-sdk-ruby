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
  module API300
    module Thunderbird
      # SAS logical interconnect resource implementation
      class SASLogicalInterconnect < Resource
        BASE_URI = '/rest/sas-logical-interconnects'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
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

        # Returns SAS logical interconnects to a consistent state.
        # The current SAS logical interconnect state is compared to the associated SAS logical interconnect group.
        # @return returns the updated object
        def compliance
          ensure_client && ensure_uri
          update_options = {
            'If-Match' =>  @data['eTag'],
            'body' => { 'type' => 'sas-logical-interconnect' }
          }
          response = @client.rest_put(@data['uri'] + '/compliance', update_options, @api_version)
          body = @client.response_handler(response)
          set_all(body)
        end

        # Gets the installed firmware for a SAS logical interconnect.
        # @return [Hash] Contains all firmware information
        def get_firmware
          ensure_client && ensure_uri
          response = @client.rest_get(@data['uri'] + '/firmware')
          @client.response_handler(response)
        end

        # Update firmware
        # @param [String] command
        # @param [OneviewSDK::FirmwareDriver] firmware_driver
        # @param [Hash] firmware_options
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def firmware_update(command, firmware_driver, firmware_options)
          ensure_client && ensure_uri
          firmware_options['command'] = command
          firmware_options['sppUri'] =  firmware_driver['uri']
          firmware_options['sppName'] = firmware_driver['name']
          update_json = {
            'If-Match' => '*',
            'body' => firmware_options
          }
          response = @client.rest_put(@data['uri'] + '/firmware', update_json)
          @client.response_handler(response)
        end

        # Initiates the replacement operation after a drive enclosure has been physically replaced.
        # @param [String] old_serial_number
        # @param [String] new_serial_number
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def replace_drive_enclosure(old_serial_number, new_serial_number)
          ensure_client && ensure_uri
          drive_enclosure_options = {
            'oldSerialNumber' => old_serial_number,
            'newSerialNumber' => new_serial_number
          }
          update_json = {
            'If-Match' => '*',
            'body' => drive_enclosure_options
          }
          response = @client.rest_post(@data['uri'] + '/replaceDriveEnclosure', update_json)
          @client.response_handler(response)
        end

        # Asynchronously applies or re-applies the SAS logical interconnect configuration to all managed interconnects
        # @return returns the updated object
        def configuration
          ensure_client && ensure_uri
          response = @client.rest_put(@data['uri'] + '/configuration', {}, @api_version)
          body = client.response_handler(response)
          set_all(body)
        end
      end
    end
  end
end
