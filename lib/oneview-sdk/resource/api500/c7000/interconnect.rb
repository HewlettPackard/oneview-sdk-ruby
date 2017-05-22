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

require_relative '../../api300/c7000/interconnect'

module OneviewSDK
  module API500
    module C7000
      # Interconnect resource implementation on API500 C7000
      class Interconnect < OneviewSDK::API300::C7000::Interconnect

        # Gets all the Small Form-factor Pluggable (SFP) instances from an interconnect.
        # @return [Hash] hash The Small Form-factor Pluggable (SFP) instances of the interconnect
        def get_pluggable_module_information
          ensure_client && ensure_uri
          response = @client.rest_get(@data['uri'] + '/pluggableModuleInformation')
          @client.response_handler(response)
        end
      end
    end
  end
end
