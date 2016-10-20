# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api200/enclosure'

module OneviewSDK
  module API300
    module Thunderbird
      # Enclosure resource implementation for API300 Thunderbird
      class Enclosure < OneviewSDK::API200::Enclosure

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          # Default values:
          @data['type'] = 'EnclosureV300'
        end

        # Claim/configure the enclosure and its components to the appliance
        # @note Calls the refresh method to set additional data
        # @return [OneviewSDK::Enclosure] self
        def add
          ensure_client
          required_attributes = %w(hostname)
          required_attributes.each { |k| raise IncompleteResource, "Missing required attribute: '#{k}'" unless @data.key?(k) }
          optional_attrs = %w(enclosureUri firmwareBaselineUri force forceInstallFirmware state unmanagedEnclosure updateFirmwareOn)

          temp_data = @data.select { |k, _v| required_attributes.include?(k) || optional_attrs.include?(k) }
          response = @client.rest_post(self.class::BASE_URI, { 'body' => temp_data }, @api_version)
          new_data = @client.response_handler(response)
          old_name = @data.select { |k, _v| %w(name rackName).include?(k) } # Save name (if given)
          %w(hostname).each { |k| @data.delete(k) } # These are no longer needed
          set_all(new_data)
          set_all(old_name)
          update
          self
        end

        # Update specific attributes of a given enclosure
        # @param [String] operation Operation to be performed
        # @param [String] path Path
        # @param [String] value Value
        def patch(operation, path, value = nil)
          ensure_client && ensure_uri
          body = if value
                   { op: operation, path: path, value: value }
                 else
                   { op: operation, path: path }
                 end
          response = @client.rest_patch(@data['uri'], { 'body' => [body] }, @api_version)
          @client.response_handler(response)
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_environmental_configuration
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_enclosure_group
          unavailable_method
        end
      end
    end
  end
end
