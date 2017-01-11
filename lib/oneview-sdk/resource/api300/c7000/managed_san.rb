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

require_relative '../../api200/managed_san'

module OneviewSDK
  module API300
    module C7000
      # Managed SAN resource implementation for API300 C7000
      class ManagedSAN < OneviewSDK::API200::ManagedSAN

        # Retrieves interconnect types
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] wwn The wwn of the switch from which the managed sans should be retrieved
        def self.get_wwn(client, wwn = nil)
          response = client.rest_get(BASE_URI + '?locate=' + wwn)
          client.response_handler(response)
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_public_attributes(_attributes)
          unavailable_method
        end
      end
    end
  end
end
