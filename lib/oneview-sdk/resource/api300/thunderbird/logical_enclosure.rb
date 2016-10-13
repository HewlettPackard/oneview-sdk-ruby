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
    module Thunderbird
      # Logical Enclosure for API version 300
      class LogicalEnclosure < OneviewSDK::API200::LogicalEnclosure

        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'LogicalEnclosureV300'
          super
        end

        # Updates specific attributes of a given logical enclosure resource
        # @param [String] operation operation to be performed
        # @param [String] path path
        # @param [String] value value
        def patch(client, received_value)
          ensure_client && ensure_uri
          response = client.rest_patch(@data['uri'], 'body' => received_value)
          client.response_handler(response)
        end
      end
    end
  end
end
