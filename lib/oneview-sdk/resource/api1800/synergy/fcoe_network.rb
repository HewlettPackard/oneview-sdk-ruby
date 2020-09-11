# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api1800/c7000/fcoe_network'

module OneviewSDK
  module API1800
    module Synergy
      # FCoE network resource implementation for API1800 Synergy
      class FCoENetwork < OneviewSDK::API1800::C7000::FCoENetwork
      end
    end
  end
end
