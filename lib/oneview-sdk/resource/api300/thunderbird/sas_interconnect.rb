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

require_relative 'resource'

module OneviewSDK
  module API300
    module Thunderbird
      # SAS Interconnect resource implementation
      class SASInterconnect < Resource
        BASE_URI = '/rest/sas-interconnects'.freeze
        TYPE_URI = '/rest/sas-interconnect-types'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def create
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def update
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def delete
          unavailable_method
        end

        # Retrieves interconnect types
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        def self.get_types(client)
          response = client.rest_get(TYPE_URI)
          response = client.response_handler(response)
          response['members']
        end

        # Retrieves the interconnect type with name
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] name Interconnect type name
        # @return [Array] Interconnect type
        def self.get_type(client, name)
          results = get_types(client)
          results.find { |interconnect_type| interconnect_type['name'] == name }
        end
      end
    end
  end
end
