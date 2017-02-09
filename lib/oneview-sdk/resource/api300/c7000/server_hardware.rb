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
require_relative 'scope'

module OneviewSDK
  module API300
    module C7000
      # Server Hardware resource implementation on API300 C7000
      class ServerHardware < OneviewSDK::API200::ServerHardware
        include OneviewSDK::API300::C7000::Scope::ScopeHelperMethods

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
