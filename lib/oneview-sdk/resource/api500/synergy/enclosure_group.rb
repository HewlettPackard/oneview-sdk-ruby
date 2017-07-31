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

require_relative '../../api300/synergy/enclosure_group'

module OneviewSDK
  module API500
    module Synergy
      # Enclosure group resource implementation on API500 Synergy
      class EnclosureGroup < OneviewSDK::API300::Synergy::EnclosureGroup
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'EnclosureGroupV400'
          super
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def get_script(*)
          unavailable_method
        end

        # Updates an enclosure group
        # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        # @raise [StandardError] if the resource save fails
        # @return [Resource] self
        def update(attributes = {})
          super(attributes)
          retrieve!
          self
        end
      end
    end
  end
end
