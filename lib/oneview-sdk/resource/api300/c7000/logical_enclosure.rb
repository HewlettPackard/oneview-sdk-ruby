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

require_relative '../../api200/logical_enclosure'
require_relative '../../../resource_helper'

module OneviewSDK
  module API300
    module C7000
      # Logical Enclosure resource implementation on API300 C7000
      class LogicalEnclosure < OneviewSDK::API200::LogicalEnclosure
        include OneviewSDK::ResourceHelper

        def initialize(client, params = {}, api_ver = nil)
          super
        end

        # Updates  the firmware attributes of a given logical enclosure resource
        # @param [Hash] attributes Hash with firmware attributes
        # @option options [String] :firmwareUpdateOn Specifies the component types within the enclosure which has to be updated
        # @option options [Boolean] :forceInstallFirmware Specifies whether the firmware operation to be carried forcefully or not
        # @option options [String] :firmwareBaselineUri Firmware-drivers URI for the firmware bundle containing the baseline firmware
        def update_firmware(attributes = {})
          patch('replace', '/firmware', attributes)
        end
      end
    end
  end
end
