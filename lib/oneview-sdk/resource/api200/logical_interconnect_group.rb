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
      end

      # Get the logical interconnect group default settings
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @return [Hash] The logical interconnect group settings
      def self.get_default_settings(client)
        response = client.rest_get(BASE_URI + '/defaultSettings', client.api_version)
        client.response_handler(response)
      end

      # Adds an interconnect
      # @param [Fixnum] bay Bay number
      # @param [String] type Interconnect type
      # @raise [StandardError] if an invalid type is given
      def add_interconnect(bay, type)
        interconnect_type = OneviewSDK::Interconnect.get_type(@client, type)
        raise OneviewSDK::NotFound unless interconnect_type

        entry_already_present = false
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
          entry['logicalLocation']['locationEntries'].each do |location|
            if location['type'] == 'Bay' && location['relativeValue'] == bay
              entry['permittedInterconnectTypeUri'] = interconnect_type['uri']
              entry_already_present = true
            end
          end
        end

        unless entry_already_present
          new_entry = new_interconnect_entry_template(bay, interconnect_type['uri'])
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << new_entry
        end

      rescue OneviewSDK::NotFound
        list = OneviewSDK::Interconnect.get_types(@client).map { |t| t['name'] }
        raise "Interconnect type #{type} not found! Supported types: #{list}"
      end

      # Adds an uplink set
      # @param [OneviewSDK::LIGUplinkSet] uplink_set
      def add_uplink_set(uplink_set)
        @data['uplinkSets'] << uplink_set.data
      end

      # Gets the logical interconnect group settings
      # @return [Hash] The logical interconnect group settings
      def get_settings
        get_uri = @data['uri'] + '/settings'
        response = @client.rest_get(get_uri, @api_version)
        @client.response_handler(response)
      end

      # Create the resource on OneView using the current data
      # @note Calls the refresh method to set additional data
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [Resource] self
      def create
        verify_interconnects_before_save!
        super
      end

      # Set data and save to OneView
      # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
      # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
      # @raise [StandardError] if the resource save fails
      # @return [Resource] self
      def update(attributes = {})
        set_all(attributes)
        ensure_client && ensure_uri
        verify_interconnects_before_save!
        update_options = {
          'If-Match' =>  @data.delete('eTag'),
          'Body' => @data
        }
        response = @client.rest_put(@data['uri'], update_options, @api_version)
        body = @client.response_handler(response)
        set_all(body)
      end

      private

      def verify_interconnects_before_save!
        return unless @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].empty?
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << new_interconnect_entry_template
      end

      def new_interconnect_entry_template(bay = 1, interconnect_type_uri = nil)
        {
          'logicalLocation' => {
            'locationEntries' => [
              { 'relativeValue' => bay, 'type' => 'Bay' },
              { 'relativeValue' => 1, 'type' => 'Enclosure' }
            ]
          },
          'permittedInterconnectTypeUri' => interconnect_type_uri
        }
      end
    end
  end
end
