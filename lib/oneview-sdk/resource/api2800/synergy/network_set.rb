# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api2600/synergy/network_set'

module OneviewSDK
  module API2800
    module Synergy
      # Network set resource implementation for API2800 Synergy
      class NetworkSet < OneviewSDK::API2600::Synergy::NetworkSet
      end
    end
  end
end
