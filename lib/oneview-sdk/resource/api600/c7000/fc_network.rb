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

require_relative '../../api300/c7000/fc_network'
require_relative 'scope'

module OneviewSDK
  module API600
    module C7000
      # FC network resource implementation for API600 C7000
      class FCNetwork < OneviewSDK::API300::C7000::FCNetwork
        include OneviewSDK::API300::C7000::Scope::ScopeHelperMethods
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['autoLoginRedistribution'] ||= false
          @data['type'] ||= 'fc-networkV4'
          @data['linkStabilityTime'] ||= 30
          @data['fabricType'] ||= 'FabricAttach'
          super
        end
      end
    end
  end
end
