# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api300/c7000/logical_enclosure'
require_relative '../../../resource_helper'

module OneviewSDK
  module API500
    module C7000
      # Contains helper methods to include operation with firmware of a given logical enclosure resource
      module FirmwareHelper
        include ResourceHelper

        # Updates  the firmware attributes of a given logical enclosure resource
        # @param [Hash] attributes Hash with firmware attributes
        # @option options [String] :firmwareUpdateOn Specifies the component types within the enclosure which has to be updated
        # @option options [Boolean] :forceInstallFirmware Specifies whether the firmware operation to be carried forcefully or not
        # @option options [String] :firmwareBaselineUri Firmware-drivers URI for the firmware bundle containing the baseline firmware
        # @return [OneviewSDK::API500::C7000::LogicalEnclosure] self
        def update_firmware(attributes = {})
          patch('replace', '/firmware', attributes, 'If-Match' => @data['eTag'])
          retrieve!
          self
        end
      end

      # Logical Enclosure resource implementation on API500 C7000
      class LogicalEnclosure < OneviewSDK::API300::C7000::LogicalEnclosure
        include OneviewSDK::API500::C7000::FirmwareHelper

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def create(*)
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def delete(*)
          unavailable_method
        end

        # Updates a logical enclosure
        # @param [Hash] attributes attributes to be updated
        # @return [OneviewSDK::API500::C7000::LogicalEnclosure] self
        def update(attributes = {})
          super(attributes)
          retrieve!
          self
        end
      end
    end
  end
end
