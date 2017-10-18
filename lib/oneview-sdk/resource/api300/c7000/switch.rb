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

require_relative '../../api200/switch'
require_relative 'scope'

module OneviewSDK
  module API300
    module C7000
      # Switch resource implementation
      class Switch < OneviewSDK::API200::Switch
        include OneviewSDK::API300::C7000::Scope::ScopeHelperMethods

        # Updates the scope URIs of a specific switch
        # @param [Array] scope_uris Array of scope uri strings
        # @deprecated Use {#add_scope}, {#remove_scope}, and {#replace_scopes} instead.
        def set_scope_uris(scope_uris)
          patch('replace', '/scopeUris', scope_uris)
        end

        # Updates the switch ports
        # @note Only the ports under the management of OneView and those that are unlinked are supported for update
        # @param [String] portName port name
        # @param [Hash] attributes hash with attributes and values to be changed
        def update_port(portName, attributes)
          ensure_uri
          port = @data['ports'].find { |p| p['portName'] == portName }
          attributes.each { |key, value| port[key.to_s] = value }
          response = @client.rest_put(@data['uri'] + '/update-ports', 'body' => [port])
          @client.response_handler(response)
        end
      end
    end
  end
end
