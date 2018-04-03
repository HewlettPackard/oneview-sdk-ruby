# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../api500/plan_script'

module OneviewSDK
  module ImageStreamer
    module API600
      # Plan Script resource implementation for Image Streamer
      class PlanScript < OneviewSDK::ImageStreamer::API500::PlanScript

        # Retrieves the read only artifacts of the selected Plan Script as per the selected attributes.
        # @return [Hash] The readonly artifacts of the selected Plan Script.
        def retrieve_read_only
          ensure_client && ensure_uri
          path = "#{BASE_URI}/#{@data['uri'].split('/').last}/usedby/readonly"
          response = @client.rest_get(path, { 'Content-Type' => 'none' }, @api_version)
          @client.response_handler(response)
        end
      end
    end
  end
end
