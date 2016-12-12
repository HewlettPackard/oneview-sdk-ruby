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

require_relative '../../api200/connection_template'

module OneviewSDK
  module API300
    module Synergy
      # Connection template resource implementation for API300 Synergy
      class ConnectionTemplate < OneviewSDK::API200::ConnectionTemplate

        # Get the default network connection template
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @return [OneviewSDK::API300::Synergy::ConnectionTemplate] Connection template
        def self.get_default(client)
          response = client.rest_get(BASE_URI + '/defaultConnectionTemplate')
          OneviewSDK::API300::Synergy::ConnectionTemplate.new(client, client.response_handler(response))
        end
      end
    end
  end
end
