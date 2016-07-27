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

module OneviewSDK
  # Interconnect resource implementation
  class Interconnect < Resource
    BASE_URI = '/rest/interconnects'.freeze
    TYPE_URI = '/rest/interconnect-types'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      super
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def create
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def update
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def delete
      unavailable_method
    end

    # Retrieves interconnect types
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    def self.get_types(client)
      response = client.rest_get(TYPE_URI)
      response = client.response_handler(response)
      response['members']
    end

    # Retrieves the interconnect type with name
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [String] name Interconnect type name
    # @return [Array] Interconnect type
    def self.get_type(client, name)
      results = get_types(client)
      results.find { |interconnect_type| interconnect_type['name'] == name }
    end

    # Retrieves the named servers for this interconnect
    def name_servers
      response = @client.rest_get(@data['uri'] + '/nameServers')
      response.body
    end

    # Updates an interconnect port
    # @param [String] portName port name
    # @param [Hash] attributes hash with attributes and values to be changed
    def update_port(portName, attributes)
      @data['ports'].each do |port|
        next unless port['name'] == portName
        attributes.each { |key, value| port[key.to_s] = value }
        response = @client.rest_put(@data['uri'] + '/ports', 'body' => port)
        @client.response_handler(response)
      end
    end

    # Get statistics for an interconnect, for the specified port or subport
    # @param [String] portName port to retrieve statistics
    # @param [String] subportNumber subport to retrieve statistics
    def statistics(portName = nil, subportNumber = nil)
      uri = if subportNumber.nil?
              "#{@data['uri']}/statistics/#{portName}"
            else
              "#{@data['uri']}/statistics/#{portName}/subport/#{subportNumber}"
            end
      response = @client.rest_get(uri)
      response.body
    end

    # Triggers the reset port protection action
    def reset_port_protection
      response = @client.rest_put(@data['uri'] + '/resetportprotection')
      @client.response_handler(response)
    end

    # Updates specific attributes for a given interconnect resource
    # @param [String] operation operation to be performed
    # @param [String] path path
    # @param [String] value value
    def patch(operation, path, value)
      response = @client.rest_patch(@data['uri'], 'body' => [{ op: operation, path: path, value: value }])
      @client.response_handler(response)
    end
  end
end
