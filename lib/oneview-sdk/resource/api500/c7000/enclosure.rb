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

require_relative '../../api300/c7000/enclosure'

module OneviewSDK
  module API500
    module C7000
      # Enclosure resource implementation for API500 C7000
      class Enclosure < OneviewSDK::API300::C7000::Enclosure

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'EnclosureV400'
          super
        end

        # Updates the name and rackName (and it uses PATCH).
        # Override in order to return the current state of the object.
        # @param [Hash] attributes attributes to be updated
        # @return [OneviewSDK::Enclosure] self
        def update(attributes = {})
          super(attributes)
          retrieve!
          self
        end

        # Performs a specific patch operation.
        # @param [String] operation The operation to be performed
        # @param [String] path The path of operation
        # @param [String] value The value
        # @return [Hash] hash with response
        # @note The scopeUris attribute is subject to incompatible changes in future release versions.
        def patch(operation, path, value = nil)
          ensure_client && ensure_uri
          body = [{ 'op' => operation, 'path' => path, 'value' => value }]
          patch_options = { 'If-Match' => @data['eTag'] }
          response = @client.rest_patch(@data['uri'], patch_options.merge('body' => body), @api_version)
          @client.response_handler(response)
        end
      end
    end
  end
end
