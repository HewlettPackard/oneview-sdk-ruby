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
  module API200
    # Id pool resource implementation
    class IDPool < Resource
      BASE_URI = '/rest/id-pools'.freeze

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

      # Gets a pool along with the list of ranges present in it.
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @raise [OneviewSDK::IncompleteResource] if the client
      # @return [OneviewSDK::API200::IDPool] The response with IDs list, count and if this is a valid allocator
      def get_pool(pool_type)
        ensure_client
        response = @client.rest_get("#{BASE_URI}/#{pool_type}")
        body = @client.response_handler(response)
        set_all(body)
        self
      end

      # Allocates one or more IDs from a according the amount informed
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @param [Array<String>] id_list The IDs list (or IDs separeted by comma)
      # @return [Hash] The list of allocated IDs
      # @note This API cannot be used to allocate IPv4 IDs. Allocation of IPv4 IDs is allowed only at the range level allocator.
      def allocate_id_list(pool_type, *id_list)
        allocate(pool_type, idList: id_list.flatten)
      end

      # Allocates a specific amount of IDs from a pool
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @param [Integer] count The amount of IDs to allocate
      # @return [Hash] The list of allocated IDs
      # @note This API cannot be used to allocate IPv4 IDs. Allocation of IPv4 IDs is allowed only at the range level allocator.
      def allocate_count(pool_type, count)
        allocate(pool_type, count: count)
      end

      # Checks the range availability in the ID pool
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @param [Array<String>] id_list The IDs list (or IDs separeted by comma)
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @return [Hash] The hash with eTag and list of ID's
      def check_range_availability(pool_type, *id_list)
        ensure_client
        response = @client.rest_get("#{BASE_URI}/#{pool_type}/checkrangeavailability?idList=#{id_list.flatten.join('&idList=')}")
        @client.response_handler(response)
      end

      # Collects one or more IDs to be returned to a pool
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @param [Array<String>] id_list The list of IDs (or IDs separeted by comma) to be collected
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @return [Hash] The list of IDs collected
      def collect_ids(pool_type, *id_list)
        ensure_client
        response = @client.rest_put("#{BASE_URI}/#{pool_type}/collector", 'body' => { 'idList' => id_list.flatten })
        @client.response_handler(response)
      end

      # Generates and returns a random range
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @return [Hash] A random range
      # @note This API is not applicable for the IPv4 IDs.
      def generate_random_range(pool_type)
        ensure_client
        response = @client.rest_get("#{BASE_URI}/#{pool_type}/generate")
        @client.response_handler(response)
      end

      # Validates a set of user specified IDs to reserve in the pool
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @param [Array<String>] id_list The list of IDs (or IDs separeted by comma)
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @return [Boolean] Returns true if is valid
      def validate_id_list(pool_type, *id_list)
        ensure_client
        response = @client.rest_put("#{BASE_URI}/#{pool_type}/validate", 'body' => { 'idList' => id_list.flatten })
        body = @client.response_handler(response)
        body['valid']
      end

      private

      # Allocates one or more IDs from a pool
      # @param [String] pool_type The type of the pool. Values: (ipv4, vmac, vsn, vwwn)
      # @param [Hash] params The parameters used to allocate IDs
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @return [Hash] The list of allocated IDs
      # @note This API cannot be used to allocate IPv4 IDs. Allocation of IPv4 IDs is allowed only at the range level allocator.
      def allocate(pool_type, params)
        ensure_client
        response = @client.rest_put("#{BASE_URI}/#{pool_type}/allocator", 'body' => params)
        @client.response_handler(response)
      end
    end
  end
end
