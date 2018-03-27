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

require_relative '../../api500/c7000/scope'

module OneviewSDK
  module API600
    module C7000
      # Scope resource implementation for API600 C7000
      class Scope < OneviewSDK::API500::C7000::Scope

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'ScopeV3'
          super
        end

        def get_resource_scopes(resource)
          scopes_uri = resource['scopesUri']
          response = client.rest_get(scopes_uri)
          @client.response_handler(response)
        end

        def replace_resource_assigned_scopes(resource, scopes: [])
          resource_uri = resource['uri']
          scope_uris = ensure_and_get_uris(scopes)
          scopes_uri = resource['scopesUri']
          options = { 'Content-Type' => 'application/json-patch+json',
                      'If-Match' => "*",
                      'body' => {'type' => "ScopedResource",
                                'resourceUri' => resource_uri,
                                'scopeUris' => scope_uris}
          }
          response = @client.rest_put(scopes_uri, options)
          @client.response_handler(response)
        end

	# Performs a specific patch operation.
        # @param [String] scopes_uri resource's scopes uri
	# @param [String] operation The operation to be performed
	# @param [String] path The path of operation
	# @param [String] value The value
        def resource_patch(scopes_uri, operation, path, value = nil)
            ensure_client && ensure_uri
            body = {
              'op' => operation,
              'path' => path,
              'value' => value
            }
            options = {'Content-Type' => 'application/json-patch+json', 'If-Match' => '*', 'body' => [body]}
            response = @client.rest_patch(scopes_uri, options, @api_version)
            @client.response_handler(response)
        end

        def add_resource_scope(resource, scope)
          scopes_uri = resource['scopesUri']
          resource_patch(scopes_uri, 'add', '/scopeUris/-', scope['uri'])
        end

        def remove_resource_scope(resource, scope)
          scope_uris = get_resource_scopes(resource)['scopeUris']
          scope_index = scope_uris.find_index { |uri| uri == scope['uri'] }
          resource_uri = resource['scopesUri']
          resource_patch(resource_uri, "remove", "/scopeUris/#{scope_index}", nil)
          true
        end
      end
    end
  end
end
