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

require_relative '../../api300/c7000/server_hardware'

module OneviewSDK
  module API500
    module C7000
      # Server Hardware resource implementation on API500 C7000
      class ServerHardware < OneviewSDK::API300::C7000::ServerHardware

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'server-hardware-7'
          super
        end

        # Gets the information describing an 'SDX' partition including a list of physical server blades represented by a server hardware.
        # @note Used with SDX enclosures only
        # @return [Hash] Hash with the physical server hardware inventory
        def get_physical_server_hardware
          ensure_client && ensure_uri
          response = @client.rest_get(@data['uri'] + '/physicalServerHardware')
          @client.response_handler(response)
        end
      end
    end
  end
end
