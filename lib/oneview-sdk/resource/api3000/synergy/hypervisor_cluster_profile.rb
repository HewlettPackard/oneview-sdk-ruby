# (c) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api3000/c7000/hypervisor_cluster_profile'

module OneviewSDK
  module API3000
    module Synergy
      # Hypervisor cluster profile resource implementation for API3000 Synergy
      class HypervisorClusterProfile < OneviewSDK::API3000::C7000::HypervisorClusterProfile
      end
    end
  end
end
