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

require_relative '../../api200/enclosure_group'

module OneviewSDK
  module API300
    module C7000
      # Enclosure group resource implementation on API300 C7000
      class EnclosureGroup < OneviewSDK::API200::EnclosureGroup

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'EnclosureGroupV300'
          @data['stackingMode'] ||= 'Enclosure'
          @data['enclosureCount'] ||= 1
          @data['interconnectBayMappingCount'] ||= 8
          super
        end

        # Adds the logical interconnect group
        # @param [OneviewSDK::LogicalInterconnectGroup] lig Logical Interconnect Group
        # @param [Integer] enclosureIndex Enclosure index of bay to add LIG to. If nil, interconnects will be added for all enclosures
        # @raise [OneviewSDK::NotFound] if the LIG uri is not set and cannot be retrieved
        # @return [OneviewSDK::API300::C7000::EnclosureGroup] self
        def add_logical_interconnect_group(lig, enclosureIndex = nil)
          lig.retrieve! unless lig['uri']
          raise(NotFound, "The logical interconnect group #{lig['name']} was not found") unless lig['uri']
          lig['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
            entry['logicalLocation']['locationEntries'].each do |location|
              next unless location['type'] == 'Bay' && entry['permittedInterconnectTypeUri']
              add_lig_to_bay(location['relativeValue'], lig, enclosureIndex)
            end
          end
          self
        end

        # Creates the interconnect bay mapping
        # @return [OneviewSDK::API300::C7000::EnclosureGroup] self
        def create_interconnect_bay_mapping
          @data['interconnectBayMappings'] = []
          1.upto(@data['enclosureCount']) do |enclosureIndex|
            1.upto(@data['interconnectBayMappingCount']) do |bay_number|
              entry = {
                'enclosureIndex' => enclosureIndex,
                'interconnectBay' => bay_number,
                'logicalInterconnectGroupUri' => nil
              }
              @data['interconnectBayMappings'] << entry
            end
          end
          self
        end

        private

        # Add logical interconnect group to bay
        # @param [Integer] bay Bay number
        # @param [OneviewSDK::LogicalInterconnectGroup] lig Logical Interconnect Group
        # @param [Integer] enclosureIndex Enclosure index of bay to add LIG to. If nil, interconnects will be added for all enclosures
        def add_lig_to_bay(bay, lig, enclosureIndex)
          @data['interconnectBayMappings'].each do |location|
            next unless location['interconnectBay'] == bay
            if enclosureIndex
              next unless location['enclosureIndex'] == enclosureIndex
              location['logicalInterconnectGroupUri'] = lig['uri']
              location['enclosureIndex'] = enclosureIndex
              break
            else
              location['logicalInterconnectGroupUri'] = lig['uri']
            end
          end
        end
      end
    end
  end
end
