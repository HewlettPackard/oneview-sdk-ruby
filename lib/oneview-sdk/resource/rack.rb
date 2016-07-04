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

module OneviewSDK
  # Rack resource implementation
  class Rack < Resource
    BASE_URI = '/rest/racks'.freeze

    alias add create
    alias remove delete

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['rackMounts'] ||= []
    end

    def create
      unavailable_method
    end

    def delete
      unavailable_method
    end

    # Add rack resource with specified options
    # @param [OneviewSDK::Resource] resource Resource to be added
    # @param [String] mount_location location in the rack
    # @options [Hash] options
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

    # Remove resource from rack
    # @param [OneviewSDK::Resource] resource Resource to be removed from rack
    def remove_rack_resource(resource)
      @data['rackMounts'].reject! { |rack_resource| rack_resource['mountUri'] == resource['uri'] }
    end


    # Get topology information for the rack
    # @return [Hash] Environmental analysis
    def get_device_topology
      response = @client.rest_get(@data['uri'] + '/deviceTopology')
      @client.response_handler(response)
    end

  end
end
