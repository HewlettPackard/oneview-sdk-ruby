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
    # Managed SAN resource implementation
    class ManagedSAN < Resource
      BASE_URI = '/rest/fc-sans/managed-sans'.freeze

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def update(*)
        unavailable_method
      end

      # Retrieves a list of endpoints
      # @return [Array] List of endpoints
      def get_endpoints
        response = @client.rest_get(@data['uri'] + '/endpoints')
        @client.response_handler(response)['members']
      end

      # Set refresh state for managed SAN
      # @param [String] state Desired refresh state
      def set_refresh_state(state)
        response = @client.rest_put(@data['uri'], 'body' => { refreshState: state })
        @client.response_handler(response)
      end

      # Set public attributes
      # @param [Hash] attributes Public attributes
      # @option attributes [String] :name
      # @option attributes [String] :value
      # @option attributes [String] :valueType
      # @option attributes [String] :valueFormat
      def set_public_attributes(attributes)
        response = @client.rest_put(@data['uri'], 'body' => { publicAttributes: attributes })
        @client.response_handler(response)
      end

      # Set public attributes
      # @param [Hash] policy SAN policy
      # @option attributes [String] :zoningPolicy
      # @option attributes [String] :zoneNameFormat
      # @option attributes [String] :enableAliasing
      # @option attributes [String] :initiatorNameFormat
      # @option attributes [String] :targetNameFormat
      # @option attributes [String] :targetGroupNameFormat
      def set_san_policy(policy)
        response = @client.rest_put(@data['uri'], 'body' => { sanPolicy: policy })
        @client.response_handler(response)
      end

      # Creates unexpected zoning report for a SAN
      def get_zoning_report
        response = @client.rest_post(@data['uri'] + '/issues', 'body' => {})
        @client.response_handler(response)
      end
    end
  end
end
