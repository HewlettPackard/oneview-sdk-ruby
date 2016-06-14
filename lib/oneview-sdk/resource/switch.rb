################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

module OneviewSDK
  # Switch resource implementation
  class Switch < Resource
    BASE_URI = '/rest/switches'.freeze
    TYPE_URI = '/rest/switch-types'.freeze

    def create
      unavailable_method
    end

    def update
      unavailable_method
    end

    def refresh
      unavailable_method
    end

    # Retrieve switch types
    # @param [Client] client http client
    # @return [Array] All the Switch types
    def self.get_types(client)
      response = client.rest_get(TYPE_URI)
      response = client.response_handler(response)
      response['members']
    end

    # Retrieve switch type with name
    # @param [Client] client http client
    # @param [String] name Switch type name
    # @return [Array] Switch type
    def self.get_type(client, name)
      results = get_types(client)
      results.find { |switch_type| switch_type['name'] == name }
    end

    # Get statistics for an interconnect, for the specified port or subport
    # @param [String] portName port to retrieve statistics
    # @param [String] subportNumber subport to retrieve statistics
    # @return [Hash] Switch statistics
    def statistics(port_name = nil, subport_number = nil)
      uri = if subport_number
              "#{@data['uri']}/statistics/#{port_name}/subport/#{subport_number}"
            else
              "#{@data['uri']}/statistics/#{port_name}"
            end
      response = @client.rest_get(uri)
      response.body
    end

    # Get settings that describe the environmental configuration
    # @return [Hash] Configuration parameters
    def environmental_configuration
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/environmentalConfiguration', @api_version)
      @client.response_handler(response)
    end

  end
end
