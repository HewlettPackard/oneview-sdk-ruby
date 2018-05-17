# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api500/synergy/enclosure'

module OneviewSDK
  module API600
    module Synergy
      # Enclosure resource implementation for API600 Synergy
      class Enclosure < OneviewSDK::API500::Synergy::Enclosure
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'EnclosureListV7'
          super
        end

        # Generate certificate signing request for the logical enclosure
        # @raise [OneviewSDK::IncompleteResource] if the client is not set
        # @raise [OneviewSDK::IncompleteResource] if the uri is not set
        # @raise [StandardError] if the reapply fails
        # @return [OneviewSDK::LogicalEnclosure] response
        def create_csr_request(options, bay_number = nil)
          ensure_client && ensure_uri
          uri = "#{@data['uri']}/https/certificaterequest"
          uri += "?bayNumber=#{bay_number}" if bay_number
          response = @client.rest_post(uri, { 'body' => options }, @api_version)
          @client.response_handler(response)
        end

        # Retrieve certificate signing request for the enclosure
        # @raise [OneviewSDK::IncompleteResource] if the client is not set
        # @raise [OneviewSDK::IncompleteResource] if the uri is not set
        # @raise [StandardError] if the reapply fails
        # @return [OneviewSDK::LogicalEnclosure] response
        def get_csr_request(bay_number = nil)
          ensure_client && ensure_uri
          uri = "#{@data['uri']}/https/certificaterequest"
          uri += "?bayNumber=#{bay_number}" if bay_number
          response = @client.rest_get(uri, {}, @api_version)
          @client.response_handler(response)
        end

        # Import certificate into the logical enclosure
        # @raise [OneviewSDK::IncompleteResource] if the client is not set
        # @raise [OneviewSDK::IncompleteResource] if the uri is not set
        # @raise [StandardError] if the reapply fails
        # @return [OneviewSDK::LogicalEnclosure] response
        def import_certificate(options, bay_number = nil)
          ensure_client && ensure_uri
          uri = "#{@data['uri']}/https/certificaterequest"
          uri += "?bayNumber=#{bay_number}" if bay_number
          response = @client.rest_put(uri, { 'body' => options }, @api_version)
          @client.response_handler(response)
        end
      end
    end
  end
end
