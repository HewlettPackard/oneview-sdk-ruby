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

        RESOURCE_BASE_URI = "#{BASE_URI}/resources"

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

        def get_resource_scope(client, resouce)
          resource_uri = ensure_and_get_uris(resource)
          uri = RESOURCE_BASE_URI << resource_uri
          response = client.rest_get(uri)
          client.response_handler(response)
        end

        #def replace_resource_scopes(client, resource, scopes: [])
        #  resource_uri = ensure_and_get_uris(resource)
        #  scope_uris = ensure_and_get_uris(scopes)
        #  uri = RESOURCE_BASE_URI << resource_uri
        #  options = { 'Content-Type' =>'application/json-patch+json'
        #              'body' = {'type' => "ScopedResource",
        #                        'resourceUri' => resource_uri,
        #                        'scopeUris' => scope_uris}
        #  }
        #  response = client.rest_patch(uri, options)
        #  client.response_handler(response)
        #end
#
#        def update_resource_scopes(client, resource)
 #         resource_uri = ensure_and_get_uris(resource)
 #
 #       end

      end
    end
  end
end
