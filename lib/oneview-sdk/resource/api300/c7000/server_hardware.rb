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

require_relative '../../api200/server_hardware'

module OneviewSDK
  module API300
    module C7000
      # Server Hardware resource implementation on API300 C7000
      class ServerHardware < OneviewSDK::API200::ServerHardware

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'server-hardware-5'
          @data['scopeUris'] ||= []
          super
        end

        # Get the firmware inventory of a server.
        # @return [Hash] Contains all firmware information
        def get_firmware_by_id
          ensure_client && ensure_uri
          response = @client.rest_get(@data['uri'] + '/firmware')
          @client.response_handler(response)
        end

        # Gets a list of firmware inventory across all servers
        # @param [Array] Array with parameters
        # @return [Array] Array of firmware inventory
        def get_firmwares(filters = [])
          ensure_client
          results = []
          uri = self.class::BASE_URI + '/*/firmware'
          uri_generate(uri, filters) unless filters.empty?
          response = @client.rest_get(uri)
          body = @client.response_handler(response)

          loop do
            members = body['members']
            members.each do |member|
              results.push(member)
            end
            break unless body['nextPageUri']
            uri = body['nextPageUri']
          end
          results
        end

        # Performs a specific patch operation for the given server.
        # If the server supports the particular operation, the operation is performed
        # and a response is returned to the caller with the results.
        # @param [String] operation The operation to be performed
        # @param [String] path The path of operation
        # @param [String] value The value
        def patch(operation, path, value = nil)
          ensure_client && ensure_uri
          body = if value
                   { op: operation, path: path, value: value }
                 else
                   { op: operation, path: path }
                 end
          response = @client.rest_patch(@data['uri'], { 'body' => [body] }, @api_version)
          @client.response_handler(response)
        end

        # Add one scope to the enclosure
        # @param [OneviewSDK::API300::C7000::Scope] scope The scope resource
        # @raise [OneviewSDK::IncompleteResource] if the uri of scope is not set
        def add_scope(scope)
          scope.ensure_uri
          patch('add', '/scopeUris/-', scope['uri'])
        end

        # Remove one scope from the enclosure
        # @param [OneviewSDK::API300::C7000::Scope] scope The scope resource
        # @return [Boolean] True if the scope was deleted and false if enclosure has not the scope
        # @raise [OneviewSDK::IncompleteResource] if the uri of scope is not set
        def remove_scope(scope)
          scope.ensure_uri
          scope_index = @data['scopeUris'].find_index { |uri| uri == scope['uri'] }
          if scope_index
            patch('remove', "/scopeUris/#{scope_index}", nil)
            true
          else
            false
          end
        end

        # Change the list of scopes in the enclosure
        # @param [Array[OneviewSDK::API300::C7000::Scope]] scopes The scopes list (or scopes separeted by comma)
        # @raise [OneviewSDK::IncompleteResource] if the uri of each scope is not set
        def replace_scopes(*scopes)
          scopes.flatten!
          uris = get_and_ensure_uri_for(scopes)
          patch('replace', '/scopeUris', uris)
        end

        private

        def uri_generate(uri, filters)
          uri << '?'
          filters.each_with_index do |filter, i|
            operation = filter[:operation]
            operation = " #{operation} " if operation != '='
            filter_string = "filter=#{filter[:name]}#{operation}'#{filter[:value]}'"
            uri << filter_string
            uri << '&' if i < (filters.size - 1)
          end
        end
      end
    end
  end
end
