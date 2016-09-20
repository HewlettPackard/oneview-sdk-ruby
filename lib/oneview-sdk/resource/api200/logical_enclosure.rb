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
    # Logical enclosure resource implementation
    class LogicalEnclosure < Resource
      BASE_URI = '/rest/logical-enclosures'.freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values
        @data['type'] ||= 'LogicalEnclosure'
      end

      # Reapplies the appliance's configuration on the enclosures
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [OneviewSDK::IncompleteResource] if the uri is not set
      # @raise [StandardError] if the reapply fails
      # @return [OneviewSDK::LogicalEnclosure] self
      def reconfigure
        ensure_client && ensure_uri
        response = @client.rest_put("#{@data['uri']}/configuration", {}, @api_version)
        @client.response_handler(response)
        self
      end

      # Makes this logical enclosure consistent with the enclosure group
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [OneviewSDK::IncompleteResource] if the uri is not set
      # @raise [StandardError] if the process fails
      # @return [OneviewSDK::LogicalEnclosure] self
      def update_from_group
        ensure_client && ensure_uri
        response = @client.rest_put("#{@data['uri']}/updateFromGroup", {}, @api_version)
        @client.response_handler(response)
        self
      end

      # Get the configuration script
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [OneviewSDK::IncompleteResource] if the uri is not set
      # @raise [StandardError] if retrieving fails
      # @return [String] script
      def get_script
        ensure_client && ensure_uri
        response = @client.rest_get("#{@data['uri']}/script", @api_version)
        response.body
      end

      # Updates the configuration script for the logical enclosure
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [OneviewSDK::IncompleteResource] if the uri is not set
      # @raise [StandardError] if the reapply fails
      # @return [OneviewSDK::LogicalEnclosure] self
      def set_script(script)
        ensure_client && ensure_uri
        response = @client.rest_put("#{@data['uri']}/script", { 'body' => script }, @api_version)
        @client.response_handler(response)
        self
      end

      # Generates a support dump for the logical enclosure
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [OneviewSDK::IncompleteResource] if the uri is not set
      # @raise [StandardError] if the process fails when generating the support dump
      # @return [OneviewSDK::LogicalEnclosure] self
      def support_dump(options)
        ensure_client && ensure_uri
        response = @client.rest_post("#{@data['uri']}/support-dumps", { 'body' => options }, @api_version)
        @client.wait_for(response.header['location'])
        self
      end
    end
  end
end
