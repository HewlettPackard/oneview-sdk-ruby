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

require_relative '../../api300/c7000/switch'

module OneviewSDK
  module API500
    module C7000
      # Switch resource implementation for API 500 C7000
      class Switch < OneviewSDK::API300::C7000::Switch

        # Method is not available
        # Use {#add_scope}, {#remove_scope}, and {#replace_scopes} instead.
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_scope_uris(*)
          unavailable_method
        end
      end
    end
  end
end
