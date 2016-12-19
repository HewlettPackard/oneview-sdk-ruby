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
    # Logical interconnect group resource implementation
    class LogicalInterconnectGroup < Resource
      BASE_URI = '/rest/logical-interconnect-groups'.freeze

      attr_reader :bay_count

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['enclosureType'] ||= 'C7000'
        @data['state'] ||= 'Active'
        @data['uplinkSets'] ||= []
        @data['type'] ||= 'logical-interconnect-groupV3'
        @data['interconnectMapTemplate'] ||= {}
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] ||= []

        # User friendly values:
        @bay_count = 8

        # Create all entries if empty
        parse_interconnect_map_template if @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] == []
      end

      # Adds an interconnect
      # @param [Fixnum] bay Bay number
      # @param [String] type Interconnect type
      # @raise [StandardError] if a invalid type is given then raises an error
      def add_interconnect(bay, type)
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
          entry['logicalLocation']['locationEntries'].each do |location|
            if location['type'] == 'Bay' && location['relativeValue'] == bay
              entry['permittedInterconnectTypeUri'] = OneviewSDK::Interconnect.get_type(@client, type)['uri']
            end
          end
        end
      rescue StandardError
        list = OneviewSDK::Interconnect.get_types(@client).map { |t| t['name'] }
        raise "Interconnect type #{type} not found! Supported types: #{list}"
      end

      # Adds an uplink set
      # @param [OneviewSDK::LIGUplinkSet] uplink_set
      def add_uplink_set(uplink_set)
        @data['uplinkSets'] << uplink_set.data
      end

      # Get the logical interconnect group default settings
      # @return [Hash] The logical interconnect group settings
      def get_default_settings
        get_uri = self.class::BASE_URI + '/defaultSettings'
        response = @client.rest_get(get_uri, @api_version)
        @client.response_handler(response)
      end

      # Gets the logical interconnect group settings
      # @return [Hash] The logical interconnect group settings
      def get_settings
        get_uri = @data['uri'] + '/settings'
        response = @client.rest_get(get_uri, @api_version)
        @client.response_handler(response)
      end

      # Saves the current data attributes to the Logical Interconnect Group
      # @param [Hash] attributes attributes to be updated
      # @return Updated instance of the Logical Interconnect Group
      def update(attributes = {})
        set_all(attributes)
        update_options = {
          'If-Match' =>  @data.delete('eTag'),
          'Body' => @data
        }
        response = @client.rest_put(@data['uri'], update_options, @api_version)
        body = @client.response_handler(response)
        set_all(body)
      end

      private

      # Parse interconnect map template structure
      def parse_interconnect_map_template
        1.upto(@bay_count) do |bay_number|
          entry = {
            'logicalDownlinkUri' => nil,
            'logicalLocation' => {
              'locationEntries' => [
                { 'relativeValue' => bay_number, 'type' => 'Bay' },
                { 'relativeValue' => 1, 'type' => 'Enclosure' }
              ]
            },
            'permittedInterconnectTypeUri' => nil
          }
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry
        end
      end
    end
  end
end
