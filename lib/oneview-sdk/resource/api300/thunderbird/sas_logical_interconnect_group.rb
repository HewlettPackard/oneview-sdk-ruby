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
  module API300
    module Synergy
      # SAS Logical interconnect group resource implementation
      class SASLogicalInterconnectGroup < Resource
        BASE_URI = '/rest/sas-logical-interconnect-groups'.freeze

        attr_reader :bay_count

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          # Default values:
          @data['enclosureType'] ||= 'SY12000'
          @data['enclosureIndexes'] ||= [1]
          @data['state'] ||= 'Active'
          @data['type'] ||= 'sas-logical-interconnect-group'
          @data['interconnectBaySet'] ||= 1
          @data['interconnectMapTemplate'] ||= {}
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] ||= []
        end

        # Adds an interconnect
        # @param [Fixnum] bay Bay number
        # @param [String] type Interconnect type
        # @raise [StandardError] if a invalid type is given then raises an error
        def add_interconnect(bay, type, enclosure_index = 1)
          parse_interconnect_map_template(bay, enclosure_index)
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
            entry['logicalLocation']['locationEntries'].each do |location|
              if location['type'] == 'Bay' && location['relativeValue'] == bay
                entry['permittedInterconnectTypeUri'] = OneviewSDK::API300::Synergy::SASInterconnect.get_type(@client, type)['uri']
              end
            end
          end
        rescue StandardError
          list = OneviewSDK::API300::Synergy::SASInterconnect.get_types(@client).map { |t| t['name'] }
          raise "SAS Interconnect type '#{type}' not found! Supported types: #{list}"
        end

        private

        # Parse interconnect map template structure for specified bay
        def parse_interconnect_map_template(bay, enclosure_index)
          entry = {
            'logicalLocation' => {
              'locationEntries' => [
                { 'relativeValue' => bay, 'type' => 'Bay' },
                { 'relativeValue' => 1, 'type' => 'Enclosure' }
              ]
            },
            'enclosureIndex' => enclosure_index,
            'permittedInterconnectTypeUri' => nil
          }

          # If no interconnect map entry templates exist yet, add the specified entry
          first_run = @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].empty?
          return @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry if first_run

          # Verifies if the bay specified in the entry is already added, otherwise adds it
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |single_entry|
            single_entry['logicalLocation']['locationEntries'].each do |location|
              return true if location['type'] == 'Bay' && location['relativeValue'] == bay
            end
          end
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry
        end
      end
    end
  end
end
