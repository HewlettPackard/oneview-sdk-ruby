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

require_relative '../c7000/interconnect'
require_relative '../../api300/synergy/interconnect'

module OneviewSDK
  module API600
    module Synergy
      # Interconnect resource implementation on API600 Synergy
      class Interconnect < OneviewSDK::API600::C7000::Interconnect

        # Retrieves the interconnect link topologies
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @return [Array] All the Interconnect Link Topologies
        def self.get_link_topologies(client)
          OneviewSDK::API300::Synergy::Interconnect.get_link_topologies(client)
        end

        # Retrieves the interconnect link topology with the name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name Switch type name
        # @return [Array] Switch type
        def self.get_link_topology(client, name)
          OneviewSDK::API300::Synergy::Interconnect.get_link_topology(client, name)
        end
      end
    end
  end
end
