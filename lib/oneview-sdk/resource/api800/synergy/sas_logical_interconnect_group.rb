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

require_relative '../../api600/synergy/sas_logical_interconnect_group'

module OneviewSDK
  module API800
    module Synergy
      # SAS Logical interconnect group resource implementation for API800 Synergy
      class SASLogicalInterconnectGroup < OneviewSDK::API600::Synergy::SASLogicalInterconnectGroup
      end
    end
  end
end