# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api1200/c7000/enclosure'

module OneviewSDK
  module API1600
    module C7000
      # Enclosure resource implementation for API1600 C7000
      class Enclosure < OneviewSDK::API1200::C7000::Enclosure
      end
    end
  end
end
