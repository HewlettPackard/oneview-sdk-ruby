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
    # Server hardware type resource implementation
    class ServerHardwareType < Resource
      BASE_URI = '/rest/server-hardware-types'.freeze

      # Remove resource from OneView
      # @return [true] if resource was removed successfully
      alias remove delete

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values
        @data['type'] ||= 'server-hardware-type-4'
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

      # Update resource attributes
      # @param [Hash] attributes attributes to be updated
      # @option attributes [String] :name server hardware type name
      # @option attributes [String] :description server hardware type description
      # @return [OneviewSDK::ServerHardwareType] self
      def update(attributes = {})
        set_all(attributes)
        ensure_client && ensure_uri
        data = @data.select { |k, _v| %w(name description).include?(k) }
        response = @client.rest_put(@data['uri'], { 'body' => data }, @api_version)
        @client.response_handler(response)
        self
      end
    end
  end
end
