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

require_relative '../../api300/c7000/scope'

module OneviewSDK
  module API500
    module C7000
      # Scope resource implementation for API500 C7000
      class Scope < OneviewSDK::API300::C7000::Scope
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        #   Defaults to the client.api_version if it exists, or the OneviewSDK::Client::DEFAULT_API_VERSION.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          @data['type'] ||= 'ScopeV2'
          super
        end

        # Modifies scope membership by adding or removing resource assignments
        # @param [Array] resources The array of resources (or any number of resources separated by comma)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def change_resource_assignments(add_resources: [], remove_resources: [])
          if !add_resources.empty? || !remove_resources.empty?
            ensure_uri && ensure_client
            add_uris = ensure_and_get_uris(add_resources)
            remove_uris = ensure_and_get_uris(remove_resources)
            body = []

            add_uris.each do |uri|
              body << { 'op' => 'add', 'path' => '/addedResourceUris/-', 'value' => uri }
            end
            body << { 'op' => 'replace', 'path' => '/removedResourceUris', 'value' => remove_uris }

            response = @client.rest_patch(@data['uri'], { 'Content-Type' => 'application/json-patch+json', 'body' => body }, @api_version)
            @client.response_handler(response)
          end
          self
        end

        # Performs a specific patch operation for the given server.
        # If the server supports the particular operation, the operation is performed
        # and a response is returned to the caller with the results.
        # @param [String] operation The operation to be performed
        # @param [String] path The path of operation
        # @param [String] value The value
        # @note This attribute is subject to incompatible changes in future release versions, including redefinition or removal.
        def patch(operation, path, value = nil)
          ensure_client && ensure_uri
          body = {
            'op' => operation,
            'path' => path,
            'value' => value
          }
          response = @client.rest_patch(@data['uri'], { 'Content-Type' => 'application/json-patch+json', 'body' => [body] }, @api_version)
          @client.response_handler(response)
        end
      end
    end
  end
end
