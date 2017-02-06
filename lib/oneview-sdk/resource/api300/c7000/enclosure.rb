# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api200/enclosure'

module OneviewSDK
  module API300
    module C7000
      # Enclosure resource implementation for API300 C7000
      class Enclosure < OneviewSDK::API200::Enclosure

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'EnclosureV300'
          @data['scopeUris'] ||= []
          super
        end

        # Add one scope to the enclosure
        # @param [OneviewSDK::API300::C7000::Scope] scope The scope resource
        # @raise [OneviewSDK::IncompleteResource] if the uri of scope is not set
        def add_scope(scope)
          scope.ensure_uri
          patch('add', '/scopeUris/-', scope['uri'])
        end

        # Remove one scope from the enclosure
        # @param [OneviewSDK::API300::C7000::Scope] scope The scope resource
        # @return [Boolean] True if the scope was deleted and false if enclosure has not the scope
        # @raise [OneviewSDK::IncompleteResource] if the uri of scope is not set
        def remove_scope(scope)
          scope.ensure_uri
          scope_index = @data['scopeUris'].find_index { |uri| uri == scope['uri'] }
          if scope_index
            patch('remove', "/scopeUris/#{scope_index}", nil)
            true
          else
            false
          end
        end

        # Change the list of scopes in the enclosure
        # @param [Array[OneviewSDK::API300::C7000::Scope]] scopes The scopes list (or scopes separeted by comma)
        # @raise [OneviewSDK::IncompleteResource] if the uri of each scope is not set
        def replace_scopes(*scopes)
          scopes.flatten!
          uris = get_and_ensure_uri_for(scopes)
          patch('replace', '/scopeUris', uris)
        end
      end
    end
  end
end
