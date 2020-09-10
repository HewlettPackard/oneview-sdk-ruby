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

require_relative '../../api1800/c7000/logical_interconnect'

module OneviewSDK
  module API2000
    module C7000
      # Logical interconnect resource implementation for API2000 C7000
      class LogicalInterconnect < OneviewSDK::API1800::C7000::LogicalInterconnect
        # Validates the bulk update from group operation and gets the consolidated inconsistency report
        def bulk_inconsistency_validate
          raise IncompleteResource, 'Please retrieve the Logical Interconnect before trying to validate' unless @data['uri']
          options = {
            'logicalInterconnectUris' => @data['logicalInterconnectUris']
          }
          response = @client.rest_post("#{BASE_URI}/bulk-inconsistency-validation", { 'body' => options }, @api_version)
          body = @client.response_handler(response)
          set_all(body)
        end

      end
    end
  end
end
