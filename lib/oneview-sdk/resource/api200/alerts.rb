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

require_relative 'resource'

module OneviewSDK
  module API200
    # Event resource implementation
    class Alerts < Resource
      BASE_URI = '/rest/alerts'.freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['type'] ||= 'AlertResourceCollectionV3'
      end

      # Gets the single alert resource identified by its ID.
      # @return [Hash] Hash containing the required information
      def get_id(client, query)
        response = @client.rest_get("#{self['uri']}")
        @client.response_handler(response)
      end

      # Retrieves alerts based on the specified filters.
      # @return [Hash] Hash containing the required information
      def get_all(client, query)
        response = @client.rest_get("#{BASE_URI}#{query_uri}")
        @client.response_handler(response)
      end


      # Deletes the single alert resource identified by its ID.
      # @return [Hash] Hash containing the required information
      def delete_id(client,query)
        response = @client.rest_delete("#{self['uri']}")
      end

      # Deletes alerts based on the specified filters.
      # @return [Hash] Hash containing the required information
      def delete_all(client, query)
        response = @client.rest_delete("#{BASE_URI}#{query_uri}")
      end
    end
  end
end
