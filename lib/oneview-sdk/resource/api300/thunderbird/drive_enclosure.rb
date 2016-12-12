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

require_relative 'resource'

module OneviewSDK
  module API300
    module Synergy
      # Drive enclosure resource implementation for API300 Synergy
      class DriveEnclosure < Resource
        BASE_URI = '/rest/drive-enclosures'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
        end

        # Method is unavailable
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def create
          unavailable_method
        end

        # Method is unavailable
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def delete
          unavailable_method
        end

        # Method is unavailable
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def update
          unavailable_method
        end

        # Retrieve the drive enclosure I/O adapter port to SAS interconnect port connectivity
        def get_port_map
          response = @client.rest_get(@data['uri'] + '/port-map')
          response.body
        end

        # Refresh a drive enclosure
        # @param [String] state Indicates if the resource is currently refreshing
        def set_refresh_state(state)
          response = @client.rest_put(@data['uri'] + '/refreshState', 'body' => { refreshState: state })
          @client.response_handler(response)
        end

        # Update specific attributes of a given drive enclosure
        # @param [String] operation Operation to be performed
        # @param [String] path Path
        # @param [String] value Value
        def patch(operation, path, value)
          response = @client.rest_patch(@data['uri'], 'body' => [{ op: operation, path: path, value: value }])
          @client.response_handler(response)
        end
      end
    end
  end
end
