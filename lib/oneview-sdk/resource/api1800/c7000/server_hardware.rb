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

require_relative '../../api1600/c7000/server_hardware'

module OneviewSDK
  module API1800
    module C7000
      # Server Hardware resource implementation on API1800 C7000
      class ServerHardware < OneviewSDK::API1600::C7000::ServerHardware
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'server-hardware-12'
          super
        end

        # Gets the local storage resource for the server, including storage controllers,
        # storage enclosures, physical drives, and logical drives.
        # @return [Hash] Contains the actual subresource data collected from the Management Processor
        def get_local_storage
          ensure_client && ensure_uri
          response = @client.rest_get(@data['uri'] + '/localStorage')
          @client.response_handler(response)
        end

        # Gets the updated version 2 local storage resource for the server, including storage controllers,
        # drives, and volumes. Starting with Gen 10 Plus, certain storage adapters will
        # provide /localStorageV2 instead of (or in addition to) /localStorage
        # @return [Hash] Contains the storage data based on the following schema.
        def get_local_storagev2
          ensure_client && ensure_uri
          response = @client.rest_get(@data['uri'] + '/localStorageV2')
          @client.response_handler(response)
        end
      end
    end
  end
end
