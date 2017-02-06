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

require_relative 'resource'

module OneviewSDK
  module ImageStreamer
    module API300
      # OS Volumes resource implementation for Image Streamer
      class OSVolumes < Resource
        BASE_URI = '/rest/os-volumes'.freeze

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def create
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def update
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def delete
          unavailable_method
        end

        # Get the details of the archived OS volume with the specified attribute.
        # @return [Hash] The details of the archived OS volume with the specified attribute
        def get_details_archive
          ensure_client && ensure_uri
          response = @client.rest_get("#{BASE_URI}/archive/#{data['uri'].split('/').last}")
          @client.response_handler(response)
        end
      end
    end
  end
end
