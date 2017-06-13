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
  module API200
    # Connection template resource implementation
    class ConnectionTemplate < Resource
      BASE_URI = '/rest/connection-templates'.freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['bandwidth'] ||= {}
        @data['type'] ||= 'connection-template'
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Get the default network connection template
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @return [OneviewSDK::ConnectionTemplate] Connection template
      def self.get_default(client)
        response = client.rest_get(BASE_URI + '/defaultConnectionTemplate')
        variant = name.split('::').at(-2)
        OneviewSDK.resource_named('ConnectionTemplate', client.api_version, variant).new(client, client.response_handler(response))
      end
    end
  end
end
