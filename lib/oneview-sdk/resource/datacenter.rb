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
  # Datacenter resource implementation
  class Datacenter < Resource
    BASE_URI = '/rest/datacenters'.freeze

    alias add create
    alias remove delete

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['contents'] ||= []
    end

    def create
      unavailable_method
    end

    def delete
      unavailable_method
    end

    # Adds existing rack to datacenter
    # @param [OneviewSDK::Rack] rack rack
    # @param [Decimal] pos_x x position
    # @param [Decimal] pos_y y position
    # @param [Decimal] rotation Rotation degrees (0-359) around the center of the resource
    def add_rack(rack, pos_x, pos_y, rotation = 0)
      @data['contents'] << {
        'resourceUri' => rack['uri'],
        'x' => pos_x,
        'y' => pos_y,
        'rotation' => rotation
      }
    end

    # Removes a rack from the datacenter
    # @param [OneviewSDK::Rack] rack rack
    def remove_rack(rack)
      @data['contents'].reject! { |resource| resource['resourceUri'] == rack['uri'] }
    end

    # Get a list of visual content objects
    # @return [Hash]
    def get_visual_content
      response = @client.rest_get(@data['uri'] + '/visualContent')
      @client.response_handler(response)
    end

  end
end
