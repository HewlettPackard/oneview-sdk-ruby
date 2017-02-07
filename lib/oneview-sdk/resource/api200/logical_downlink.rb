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
    # Logical downlink resource implementation
    class LogicalDownlink < Resource
      BASE_URI = '/rest/logical-downlinks'.freeze

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def update(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Gets a list of logical downlinks, excluding any existing ethernet network
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @return [Array<OneviewSDK::LogicalDownlink] Logical downlink array
      def self.get_without_ethernet(client)
        result = []
        response = client.rest_get(BASE_URI + '/withoutEthernet')
        members = client.response_handler(response)['members']
        members.each { |member| result << new(client, member) }
        result
      end

      # Gets a logical downlink, excluding any existing ethernet network
      # @return [OneviewSDK::LogicalDownlink] Logical downlink array
      def get_without_ethernet
        response = @client.rest_get(@data['uri'] + '/withoutEthernet')
        OneviewSDK::LogicalDownlink.new(@client, @client.response_handler(response))
      end
    end
  end
end
