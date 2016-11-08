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

require_relative '../c7000/logical_enclosure'

module OneviewSDK
  module API300
    module Thunderbird
      # Logical Enclosure resource implementation on API300 Thunderbird
      class LogicalEnclosure < OneviewSDK::API300::C7000::LogicalEnclosure

        def initialize(client, params = {}, api_ver = nil)
          super
        end

        # Sets the enclosure group for the logical enclosure
        # @param [OneviewSDK::API300::Thunderbird::EnclosureGroup] enclosure_group Enclosure Group that the Server is a member
        def set_enclosure_group(enclosure_group)
          self['enclosureGroupUri'] = enclosure_group['uri'] if enclosure_group['uri'] || enclosure_group.retrieve!
          raise "Resource #{enclosure_group['name']} could not be found!" unless enclosure_group['uri']
        end

        # Sets a list of enclosures uris for the logical enclosure
        # @param [Array] Array of OneviewSDK::API300::Thunderbird::Enclosure
        def set_enclosures(enclosures = [])
          enclosureUris = []
          enclosures.each do |enclosure|
            enclosureUris.push(enclosure['uri']) if enclosure['uri'] || enclosure.retrieve!
            raise "Resource #{enclosure['name']} could not be found!" unless enclosure['uri']
          end

          raise 'EnclosureUris is empty!' if enclosureUris.empty?
          self['enclosureUris'] = enclosureUris unless enclosureUris.empty?
        end

        # Sets the firmware driver uri for the logical enclosure
        # @param [OneviewSDK::API300::Thunderbird::FirmwareDriver] firmware The firmware driver
        def set_firmware_driver(firmware)
          self['firmwareBaselineUri'] = firmware['uri'] if firmware['uri'] || firmware.retrieve!
          raise "Resource #{firmware['customBaselineName']} could not be found!" unless firmware['uri']
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_script
          unavailable_method
        end
      end
    end
  end
end
