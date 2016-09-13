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
  # Enclosure group resource implementation
  class EnclosureGroup < Resource
    BASE_URI = '/rest/enclosure-groups'.freeze

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'EnclosureGroupV200'
      @data['interconnectBayMappingCount'] ||= 8
      create_interconnect_bay_mapping unless @data['interconnectBayMappings']
    end

    # Get the script executed by enclosures in this enclosure group
    # @return [String] The script for this enclosure group
    def get_script
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/script', @api_version)
      @client.response_handler(response)
    end

    # Changes the script executed by the enclosures in this enclosure group
    # @param [String] body The script to be executed
    # @return true if set successfully
    def set_script(body)
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'] + '/script', { 'body' => body }, @api_version)
      @client.response_handler(response)
      true
    end

    # Adds the logical interconnect group
    # @param [OneviewSDK::LogicalInterconnectGroup] lig Logical Interconnect Group
    def add_logical_interconnect_group(lig)
      lig.retrieve! unless lig['uri']
      lig['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          add_lig_to_bay(location['relativeValue'], lig) if location['type'] == 'Bay' && entry['permittedInterconnectTypeUri']
        end
      end
    end

    # Creates the interconnect bay mapping
    def create_interconnect_bay_mapping
      @data['interconnectBayMappings'] = []
      1.upto(@data['interconnectBayMappingCount']) do |bay_number|
        entry = {
          'interconnectBay' => bay_number,
          'logicalInterconnectGroupUri' => nil
        }
        @data['interconnectBayMappings'] << entry
      end
    end

    private

    # Add logical interconnect group to bay
    # @param [Integer] bay Bay number
    # @param [OneviewSDK::LogicalInterconnectGroup] lig Logical Interconnect Group
    def add_lig_to_bay(bay, lig)
      @data['interconnectBayMappings'].each do |location|
        return location['logicalInterconnectGroupUri'] = lig['uri'] if location['interconnectBay'] == bay
      end
    end

  end
  end
end
