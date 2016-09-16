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
  module API200
    # Switch resource implementation
    class Switch < Resource
      BASE_URI = '/rest/switches'.freeze
      TYPE_URI = '/rest/switch-types'.freeze

      # Remove resource from OneView
      # @return [true] if resource was removed successfully
      alias remove delete

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
      def refresh
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete
        unavailable_method
      end

      # Retrieves the switch types
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @return [Array] All the Switch types
      def self.get_types(client)
        response = client.rest_get(TYPE_URI)
        response = client.response_handler(response)
        response['members']
      end

      # Retrieves the switch type with the name
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [String] name Switch type name
      # @return [Array] Switch type
      def self.get_type(client, name)
        results = get_types(client)
        results.find { |switch_type| switch_type['name'] == name }
      end

      # Get statistics for an interconnect, for the specified port or subport
      # @param [String] port_name port to retrieve statistics
      # @param [String] subport_number subport to retrieve statistics
      # @return [Hash] Switch statistics
      def statistics(port_name = nil, subport_number = nil)
        uri = if subport_number
                "#{@data['uri']}/statistics/#{port_name}/subport/#{subport_number}"
              else
                "#{@data['uri']}/statistics/#{port_name}"
              end
        response = @client.rest_get(uri)
        response.body
      end

      # Get settings that describe the environmental configuration
      # @return [Hash] Configuration parameters
      def environmental_configuration
        ensure_client && ensure_uri
        response = @client.rest_get(@data['uri'] + '/environmentalConfiguration', @api_version)
        @client.response_handler(response)
      end
    end
  end
end
