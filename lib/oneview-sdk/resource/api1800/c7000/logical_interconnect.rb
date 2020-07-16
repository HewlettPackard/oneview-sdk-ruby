# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api1600/c7000/logical_interconnect'

module OneviewSDK
  module API1800
    module C7000
      # Logical interconnect resource implementation for API1800 C7000
      class LogicalInterconnect < OneviewSDK::API1600::C7000::LogicalInterconnect
        # Gets igmpSettings of logical interconnect
        def get_igmp_settings
          ensure_client && ensure_uri
          response = @client.rest_get("#{@data['uri']}/igmpSettings")
          @client.response_handler(response)
          body = @client.response_handler(response)
          body['members']
        end

        # Updates igmpSettings for LI
        def update_igmp_settings
          raise IncompleteResource, 'Please retrieve the Logical Interconnect before trying to update' unless @data['igmpSettings']
          update_options = {
            'If-Match' =>  @data['igmpSettings'].delete('eTag'),
            'body' => @data['igmpSettings']
          }
          response = @client.rest_put("#{@data['uri']}/igmpSettings", update_options, @api_version)
          body = @client.response_handler(response)
          set_all(body)
        end
      end
    end
  end
end
