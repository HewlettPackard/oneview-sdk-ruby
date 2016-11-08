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

module OneviewSDK
  module API300
    module Thunderbird
      # Logical switch resource implementation for API300 Thunderbird (internal link set endpoints only)
      class LogicalSwitch
        # Retrieves all internal link sets
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        def self.get_internal_link_sets(client)
          OneviewSDK::API300::C7000::LogicalSwitch.get_internal_link_sets(client)
        end

        # Retrieves the internal link set with name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name The internal link set name
        # @return [Array] Internal Link Set Array
        def self.get_internal_link_set(client, name)
          OneviewSDK::API300::C7000::LogicalSwitch.get_internal_link_set(client, name)
        end
      end
    end
  end
end
