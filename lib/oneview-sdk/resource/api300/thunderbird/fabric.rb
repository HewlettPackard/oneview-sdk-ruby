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

require_relative '../../api200/fabric'

module OneviewSDK
  module API300
    module Thunderbird
      # Fabric resource implementation for API300 Thunderbird
      class Fabric < OneviewSDK::API200::Fabric

        # Get the configuration script
        # @raise [OneviewSDK::IncompleteResource] if the client is not set
        # @raise [OneviewSDK::IncompleteResource] if the uri is not set
        # @raise [StandardError] if retrieving fails
        # @return [String] script
        def get_reserved_vlan_range
          ensure_client && ensure_uri
          response = @client.rest_get("#{@data['uri']}/reserved-vlan-range", @api_version)
          @client.response_handler(response)
          # response.body
        end

        # Updates the configuration script for the logical enclosure
        # @raise [OneviewSDK::IncompleteResource] if the client is not set
        # @raise [OneviewSDK::IncompleteResource] if the uri is not set
        # @raise [StandardError] if the reapply fails
        # @return [OneviewSDK::LogicalEnclosure] self
        def set_reserved_vlan_range(options)
          ensure_client && ensure_uri
          response = @client.rest_put("#{@data['uri']}/reserved-vlan-range", { 'body' => options }, @api_version)
          @client.response_handler(response)
          self
        end
      end
    end
  end
end
