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

require_relative '../../api200/logical_downlink'

module OneviewSDK
  module API300
    module C7000
      # Logical downlink resource implementation for API300 C7000
      class LogicalDownlink < OneviewSDK::API200::LogicalDownlink

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def self.get_without_ethernet(*)
          raise MethodUnavailable, 'The method #self.get_without_ethernet is unavailable for this resource'
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def get_without_ethernet(*)
          unavailable_method
        end
      end
    end
  end
end
