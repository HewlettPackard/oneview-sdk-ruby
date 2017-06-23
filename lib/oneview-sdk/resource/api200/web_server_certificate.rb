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
    # Client certificate resource implementation
    class WebServerCertificate < Resource
      BASE_URI = '/rest/certificates/https'.freeze

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

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create!(*)
        unavailable_method
      end

      # Retrieves the existing SSL certificate information
      # @return [Boolean] Whether or not retrieve was successful
      def retrieve!
        response = @client.rest_get(self.class::BASE_URI)
        body = @client.response_handler(response)
        set_all(body)
        true
      end

      # Retrieves the existing SSL certificate information
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [String] address The hostname or IP address
      # @param [Hash] options The header options of request (key-value pairs)
      # @return [Boolean] Whether or not retrieve was successful
      # @return [WebServerCertificate] the resource
      def self.get_certificate(client, address, options = { 'requestername' => 'DEFAULT' })
        response = client.rest_api(:get, self::BASE_URI + "/remote/#{address}", options)
        body = client.response_handler(response)
        new(client, body)
      end

      # Imports a signed server certificate into the appliance
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @return [Resource] self
      def import
        ensure_client
        response = @client.rest_put(self.class::BASE_URI + '/certificaterequest', { 'body' => @data }, @api_version)
        body = @client.response_handler(response)
        set_all(body)
      end

      # Creates a Certificate Signing Request (CSR) using input certificate data and returns the newly-created CSR.
      # @note Calls the refresh method to set additional data
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create
        ensure_client
        response = @client.rest_post(self.class::BASE_URI + '/certificaterequest', { 'body' => @data }, @api_version)
        body = @client.response_handler(response)
        set_all(body)
      end

      # Creates a new self-signed appliance certificate based on the certificate data provided.
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create_self_signed
        ensure_client
        response = @client.rest_put(self.class::BASE_URI, { 'body' => @data }, @api_version)
        body = @client.response_handler(response)
        set_all(body)
      end
    end
  end
end
