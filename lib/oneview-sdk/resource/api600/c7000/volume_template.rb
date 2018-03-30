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

require_relative '../../api500/c7000/volume_template'

module OneviewSDK
  module API600
    module C7000
      # Volume Template resource implementation for API600 C7000
      class VolumeTemplate < OneviewSDK::API500::C7000::VolumeTemplate
        BASE_URI = '/rest/storage-volume-templates'.freeze

        # Gets the storage templates that are connected to this set of expected network URIs
        # or that are scoped to the set of scope URIs or which only allow private volumes
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] attributes Hash containing the attributes name and value to filter storage templates
        # @param [Hash] query The query options for the request (key-value pairs)
        # @return [Array] the collection of volume templates
        def self.get_reachable_volume_templates(client, attributes = {}, query = nil)
          query_uri = build_query(query) if query
          find_by(client, attributes, "#{BASE_URI}/reachable-volume-templates#{query_uri}")
        end
      end
    end
  end
end
