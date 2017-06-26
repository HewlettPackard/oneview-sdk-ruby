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
    class ClientCertificate < Resource
      BASE_URI = '/rest/certificates'.freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values
        @data['type'] ||= 'SSLCertificateDTO'
        @data['uri']  ||= "#{self.class::BASE_URI}/#{@data['aliasName']}" if @data['aliasName']
      end

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

      # Imports the given SSL certificate into the appliance trust store.
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource import fails
      # @return [Resource] self
      def import(options = { 'requestername' => 'DEFAULT' })
        ensure_client
        options['body'] = @data
        response = @client.rest_post(self.class::BASE_URI, options, @api_version)
        body = @client.response_handler(response)
        set_all(body)
        self
      end

      # Imports the given list of SSL certificates into the appliance trust store.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Array<ClientCertificate>] certificates The Client Certificate list
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @raise [ArgumentError] if the certificates list is nil or empty
      # @return [Array<ClientCertificate>] list of Client Certificate imported
      def self.import(client, certificates, options = { 'requestername' => 'DEFAULT' })
        raise ArgumentError, 'the certificates list should be valid' if certificates.nil? || certificates.empty?
        options['body'] = certificates.map(&:data)
        response = client.rest_post(self::BASE_URI + '?multiResource=true', options)
        body = client.response_handler(response)
        body.map { |data| new(client, data) }
      end

      # Updates this object using the data that exists on OneviewSDK
      # @note Will overwrite any data that differs from OneView
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @return [Resource] self
      def refresh(options = { 'requestername' => 'DEFAULT' })
        ensure_client && ensure_uri
        response = @client.rest_api(:get, @data['uri'], options, @api_version)
        body = @client.response_handler(response)
        set_all(body)
        self
      end

      # Replaces the existing SSL certificate with a new certificate for the certificate alias name provided
      # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
      # @raise [StandardError] if the resource save fails
      # @return [Resource] self
      def update(attributes = {}, options = { 'requestername' => 'DEFAULT' })
        set_all(attributes)
        ensure_client && ensure_uri
        options['body'] = @data
        response = @client.rest_put(@data['uri'], options, @api_version)
        body = @client.response_handler(response)
        set_all(body)
        self
      end

      # Replaces a list of existing SSL certificates with a new list of certificates.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Array<ClientCertificate>] certificates The Client Certificate list
      # @param [Boolean] force If set to true, the operation completes despite any problems with network connectivity or errors on the resource itself
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @return [Array<ClientCertificate>] list of the Client Certificate
      def self.replace(client, certificates, force = false, options = { 'requestername' => 'DEFAULT' })
        raise ArgumentError, 'the certificates list should be valid' if certificates.nil? || certificates.empty?
        options['body'] = certificates.map(&:data)
        uri = self::BASE_URI + '?multiResource=true'
        uri += '&force=true' if force
        response = client.rest_put(uri, options)
        body = client.response_handler(response)
        body.map { |data| new(client, data) }
      end

      # Delete resource from OneView
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @return [true] if resource was deleted successfully
      def remove(options = { 'requestername' => 'DEFAULT' })
        ensure_client && ensure_uri
        response = @client.rest_delete(@data['uri'], options, @api_version)
        @client.response_handler(response)
        true
      end

      # Removes a list of SSL certificates based on the list of alias names provided as filter criteria.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Array<String>] alias_names The alias names list used as filter to remove the client certificates
      # @param [Boolean] force If set to true, the operation completes despite any problems with network connectivity or errors on the resource itself
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @raise [ArgumentError] if the certificates list is nil or empty
      def self.remove(client, alias_names, force = false, options = { 'requestername' => 'DEFAULT' })
        raise ArgumentError, 'the certificates list should be valid' if alias_names.nil? || alias_names.empty?
        uri = self::BASE_URI + '?multiResource=true'
        uri += '&force=true' if force
        uri += '&filter=' + alias_names.join('&filter=')
        response = client.rest_delete(uri, options)
        client.response_handler(response)
      end

      # Make a GET request to the uri, and returns an array with all results (search using resource pagination)
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [String] uri URI of the endpoint
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @return [Array<Hash>] Results
      def self.find_with_pagination(client, uri, options = { 'requestername' => 'DEFAULT' })
        all = []
        loop do
          response = client.rest_api(:get, uri, options)
          body = client.response_handler(response)
          members = body['members']
          break unless members
          all.concat(members)
          break unless body['nextPageUri'] && (body['nextPageUri'] != body['uri'])
          uri = body['nextPageUri']
        end
        all
      end

      # Validates the input certificate by verifying if it is X509 compliant.
      # @param [Hash] options The header options of request (key-value pairs)
      # @option options [String] :requestername Used to identify requester to allow querying of proper trust store.
      #   Default value is "DEFAULT". List of valid input values are { "DEFAULT", "AUTHN", "RABBITMQ", "ILOOA" }.
      # @option options [String] :Accept-Language The language code requested in the response.
      #   If a suitable match to the requested language is not available, en-US or the appliance locale is used.
      # @raise [OneviewSDK::IncompleteResource] if the client or the uri is not set
      # @return [OneviewSDK::ClientCertificate] self
      def validate(options = { 'requestername' => 'DEFAULT' })
        ensure_client && ensure_uri
        options['body'] = @data
        response = @client.rest_post(self.class::BASE_URI + '/validator', options, @api_version)
        body = @client.response_handler(response)
        set_all(body)
        self
      end
    end
  end
end
