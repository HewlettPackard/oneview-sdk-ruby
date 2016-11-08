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

require_relative '../../api200/logical_enclosure'

module OneviewSDK
  module API300
    module C7000
      # Logical Enclosure resource implementation on API300 C7000
      class LogicalEnclosure < OneviewSDK::API200::LogicalEnclosure

        def initialize(client, params = {}, api_ver = nil)
          super
        end

        # Updates specific attributes of a given logical enclosure resource
        # @param [String] value Value
        def patch(value)
          ensure_client && ensure_uri
          body = { op: 'replace', path: '/firmware', value: value }
          response = @client.rest_patch(@data['uri'], { 'body' => [body] }, @api_version)
          @client.response_handler(response)
        end
      end
    end
  end
end
