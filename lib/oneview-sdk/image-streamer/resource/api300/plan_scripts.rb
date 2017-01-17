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

require_relative 'resource'

module OneviewSDK
  module ImageStreamer
    module API300
      # Plan Scripts resource implementation for Image Streamer
      class PlanScripts < Resource
        BASE_URI = '/rest/plan-scripts'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          # Default values:
          @data['type'] ||= 'PlanScript'
        end

        # Retrieves the modified contents of the selected Plan Script as per the selected attributes.
        # @return The script differences of the selected Plan Script
        def retrieve_differences
          response = @client.rest_post("#{BASE_URI}/differences/#{extract_id_from_uri}")
          @client.response_handler(response)
        end

        private

        # Extracts the id of the uri.
        # @return The id of the plan script
        def extract_id_from_uri
          @data['uri'].split('/').last
        end
      end
    end
  end
end
