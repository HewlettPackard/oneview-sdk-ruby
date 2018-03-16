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

require_relative '../../api500/c7000/server_hardware'

module OneviewSDK
  module API600
    module C7000
      # Server Hardware resource implementation on API600 C7000
      class ServerHardware < OneviewSDK::API500::C7000::ServerHardware

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'server-hardware-8'
          super
        end

        # Adds multiple server hardware using the given data
        def add_multiple_servers
          ensure_client
          required_attributes = %w[username password licensingIntent mpHostsAndRanges]
          required_attributes.each { |k| raise IncompleteResource, "Missing required attribute: '#{k}'" unless @data.key?(k) }

          optional_attrs = %w[configurationState force restore]
          temp_data = @data.select { |k, _v| required_attributes.include?(k) || optional_attrs.include?(k) }
          @client.rest_post('/rest/server-hardware' + '/discovery', { 'body' => temp_data }, @api_version)
        end
      end
    end
  end
end
