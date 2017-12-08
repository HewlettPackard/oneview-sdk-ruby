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

require_relative 'resource'

module OneviewSDK
  module API300
    module C7000
      # Scope resource implementation for API300 C7k
      class Scope < Resource
        BASE_URI = '/rest/scopes'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        #   Defaults to the client.api_version if it exists, or the OneviewSDK::Client::DEFAULT_API_VERSION.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          @data['type'] ||= 'Scope'
          super
        end

        # Set data and save to OneView
        # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        # @raise [StandardError] if the resource save fails
        # @return [Resource] self
        def update(attributes = {})
          set_all(attributes)
          ensure_client && ensure_uri
          options = {
            'If-Match' => @data.delete('eTag'),
            'body' => @data
          }
          response = @client.rest_put(@data['uri'], options, @api_version)
          @client.response_handler(response)
          self
        end

        # Delete resource from OneView
        # @param [Hash] header The header options for the request (key-value pairs)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        # @return [true] if resource was deleted successfully
        def delete(header = {})
          super(DEFAULT_REQUEST_HEADER.merge(header).merge('If-Match' => @data['eTag']))
        end

        # Adds resource assignments
        # @param [Array] *resources The array of resources (or any number of resources separated by comma)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def set_resources(*resources)
          change_resource_assignments(add_resources: resources.flatten)
        end

        # Removes resource assignments
        # @param [Array] *resources The array of resources (or any number of resources separated by comma)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def unset_resources(*resources)
          change_resource_assignments(remove_resources: resources.flatten)
        end

        # Modifies scope membership by adding or removing resource assignments
        # @param [Array] resources The array of resources (or any number of resources separated by comma)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        def change_resource_assignments(add_resources: [], remove_resources: [])
          if !add_resources.empty? || !remove_resources.empty?
            ensure_uri && ensure_client
            add_uris = ensure_and_get_uris(add_resources)
            remove_uris = ensure_and_get_uris(remove_resources)
            body = {
              'addedResourceUris' => add_uris,
              'removedResourceUris' => remove_uris
            }
            response = @client.rest_patch(@data['uri'] + '/resource-assignments', 'body' => body)
            @client.response_handler(response)
          end
          self
        end

        # Helper methods for add, remove and replace scopes from the another resources
        module ScopeHelperMethods
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
            response = @client.rest_patch(@data['uri'], { 'body' => [body] }, @api_version)
            @client.response_handler(response)
          end

          # Add one scope to the resource
          # @param [OneviewSDK::API300::C7000::Scope] scope The scope resource
          # @raise [OneviewSDK::IncompleteResource] if the uri of scope is not set
          def add_scope(scope)
            scope.ensure_uri
            patch('add', '/scopeUris/-', scope['uri'])
          end

          # Remove one scope from the resource
          # @param [OneviewSDK::API300::C7000::Scope] scope The scope resource
          # @return [Boolean] True if the scope was deleted and false if enclosure has not the scope
          # @raise [OneviewSDK::IncompleteResource] if the uri of scope is not set
          def remove_scope(scope)
            scope.ensure_uri
            scope_index = @data['scopeUris'].find_index { |uri| uri == scope['uri'] }
            return false unless scope_index
            patch('remove', "/scopeUris/#{scope_index}", nil)
            true
          end

          # Change the list of scopes in the resource
          # @param [Array<OneviewSDK::API300::C7000::Scope>] scopes The scopes list (or scopes separeted by comma)
          # @raise [OneviewSDK::IncompleteResource] if the uri of each scope is not set
          def replace_scopes(*scopes)
            uris = ensure_and_get_uris(scopes.flatten)
            patch('replace', '/scopeUris', uris)
          end
        end
      end
    end
  end
end
