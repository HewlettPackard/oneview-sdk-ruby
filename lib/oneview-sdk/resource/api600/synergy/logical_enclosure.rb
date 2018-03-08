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

require_relative '../../api300/synergy/logical_enclosure'
require_relative '../c7000/logical_enclosure'

module OneviewSDK
  module API600
    module Synergy
      # Logical Enclosure resource implementation on API600 Synergy
      class LogicalEnclosure < OneviewSDK::API300::Synergy::LogicalEnclosure
        include OneviewSDK::API600::C7000::FirmwareHelper

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def get_script(*)
          unavailable_method
        end

        # Updates a logical enclosure
        # @param [Hash] attributes attributes to be updated
        # @return [OneviewSDK::API600::Synergy::LogicalEnclosure] self
        def update(attributes = {})
          super(attributes)
          retrieve!
          self
        end
      end
    end
  end
end
