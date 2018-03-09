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

require_relative '../../api300/c7000/managed_san'

module OneviewSDK
  module API600
    module C7000
      # Managed SAN resource implementation for API600 C7000
      class ManagedSAN < OneviewSDK::API300::C7000::ManagedSAN

        # Set public attributes
        # @param [Hash] attributes Public attributes
        # @option attributes [String] :name
        # @option attributes [String] :value
        # @option attributes [String] :valueType
        # @option attributes [String] :valueFormat
        def set_public_attributes(attributes)
          OneviewSDK::API200::ManagedSAN.instance_method(:set_public_attributes).bind(self).call(attributes)
        end
      end
    end
  end
end
