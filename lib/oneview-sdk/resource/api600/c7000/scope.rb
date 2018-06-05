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

        # Gets a resource's scope, containing a list of the scopes to which
        # the resource is assigned.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [OneviewSDK::API600::C7000::Resource] resource Resource object
        def self.get_resource_scopes(client, resource)
          scopes_uri = resource['scopesUri']
          response = client.rest_get(scopes_uri)
          client.response_handler(response)
        end

        # Replaces a resource's assigned scopes using the specified list of scope URIs.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [OneviewSDK::API600::C7000::Resource] resource Resource object
        # @param [Array<OneviewSDK::API600::C7000::Scope>] scopes  Array of scopes objects
        def self.replace_resource_assigned_scopes(client, resource, scopes: [])
          resource_uri = resource['uri']
          scope_uris = scopes.map { |scope| scope['uri'] }
          scopes_uri = resource['scopesUri']
          options = { 'Content-Type' => 'application/json-patch+json',
                      'If-Match' => '*',
                      'body' => { 'type' => 'ScopedResource',
                                  'resourceUri' => resource_uri,
                                  'scopeUris' => scope_uris } }
          response = client.rest_put(scopes_uri, options)
          client.response_handler(response)
        end

        # Performs a specific patch operation.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [OneviewSDK::API600::C7000::Resource] resource Any resource object
        # @param [Array<OneviewSDK::API600::C7000::Scope>] scopes Array of scopes objects
        def self.resource_patch(client, resource, add_scopes: [], remove_scopes: [])
          scopes_body = []
          scopes_uri = resource['scopesUri']
          unless add_scopes.empty?
            add_scopes.each do |scope|
              add_body = { 'op' => 'add', 'path' => '/scopeUris/-', 'value' => scope['uri'] }
              scopes_body.push(add_body)
            end
          end
          unless remove_scopes.empty?
            remove_scopes.each do |scope|
              scope_uris = get_resource_scopes(client, resource)['scopeUris']
              scope_index = scope_uris.find_index { |uri| uri == scope['uri'] }
              remove_body = { 'op' => 'remove', 'path' => "/scopeUris/#{scope_index}" }
              scopes_body.push(remove_body)
            end
          end
          options = { 'Content-Type' => 'application/json-patch+json',
                      'If-Match' => '*', 'body' => scopes_body }
          response = client.rest_patch(scopes_uri, options, client.api_version)
          client.response_handler(response)
        end

        # Add a scope to resource's scope list
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [OneviewSDK::API600::C7000::Resource] resource Any resource object
        # @param [Array] scopes The array of scopes (or any number of scopes separated by comma)
        def self.add_resource_scope(client, resource, scopes: [])
          resource_patch(client, resource, add_scopes: scopes)
        end

        # Remove a scope from resource's scope list.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [OneviewSDK::API600::C7000::Resource] resource Any resource object
        # @param [Array] scopes The array of scopes (or any number of scopes separated by comma)
        def self.remove_resource_scope(client, resource, scopes: [])
          resource_patch(client, resource, remove_scopes: scopes)
        end
      end
    end
  end
end
