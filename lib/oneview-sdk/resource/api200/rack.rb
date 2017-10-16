# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative 'resource'

module OneviewSDK
  module API200
    # Rack resource implementation
    class Rack < Resource
      BASE_URI = '/rest/racks'.freeze
      UNIQUE_IDENTIFIERS = %w[name uri serialNumber].freeze

      # Add the resource on OneView using the current data
      # @note Calls the refresh method to set additional data
      # @raise [OneviewSDK::IncompleteResource] if the client is not set
      # @raise [StandardError] if the resource creation fails
      # @return [OneviewSDK::Rack] self
      alias add create

      # Remove resource from OneView
      # @return [true] if resource was removed successfully
      alias remove delete

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['rackMounts'] ||= []
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def create(*)
        unavailable_method
      end

      # Method is not available
      # @raise [OneviewSDK::MethodUnavailable] method is not available
      def delete(*)
        unavailable_method
      end

      # Adds the rack resource with specified options
      # @param [OneviewSDK::Resource] resource Resource to be added
      # @param [String] options rack options
      def add_rack_resource(resource, options = {})
        rack_resource_options = {}
        # Write values to hash and transform any symbol to string
        options.each { |key, val| rack_resource_options[key.to_s] = val }

        # Verify if the rack resource exists in the rack, if not init add it
        rack_resource = @data['rackMounts'].find { |resource_from_rack| resource_from_rack['mountUri'] == resource['uri'] }
        if rack_resource
          rack_resource_options.each { |key, val| rack_resource[key] = val }
        else
          # Set default values if not given
          rack_resource_options['mountUri'] = resource['uri']
          rack_resource_options['location'] = 'CenterFront' unless rack_resource_options['location']
          @data['rackMounts'] << rack_resource_options
        end
      end

      # Remove resources from the rack
      # @param [OneviewSDK::Resource] resource Resource to be removed from rack
      def remove_rack_resource(resource)
        @data['rackMounts'].reject! { |rack_resource| rack_resource['mountUri'] == resource['uri'] }
      end

      # Gets topology information for the rack
      # @return [Hash] Environmental analysis
      def get_device_topology
        response = @client.rest_get(@data['uri'] + '/deviceTopology')
        @client.response_handler(response)
      end
    end
  end
end
