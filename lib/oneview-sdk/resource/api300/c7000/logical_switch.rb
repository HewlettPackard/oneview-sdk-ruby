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

require_relative '../../api200/logical_switch'

module OneviewSDK
  module API300
    module C7000
      class LogicalSwitch < OneviewSDK::API200::LogicalSwitch
        INTERNAL_LINK_SET_URI = '/rest/internal-link-sets'.freeze

        # Retrieves all internal link sets
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        def self.get_internal_link_sets(client)
          response = client.rest_get(INTERNAL_LINK_SET_URI)
          response = client.response_handler(response)
          response['members']
        end

        # Retrieves the internal link set with name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name The internal link set name
        # @return [Array] Internal Link Set Array
        def self.get_internal_link_set(client, name)
          results = get_internal_link_sets(client)
          results.find { |internal_link_set| internal_link_set['name'] == name }
        end
      end
    end
  end
end
