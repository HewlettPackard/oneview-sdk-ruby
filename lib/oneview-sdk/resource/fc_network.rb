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

module OneviewSDK
  # FC network resource implementation
  class FCNetwork < Resource
    BASE_URI = '/rest/fc-networks'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['autoLoginRedistribution'] ||= false
      @data['type'] ||= 'fc-networkV2'
      @data['linkStabilityTime'] ||= 30
      @data['fabricType'] ||= 'FabricAttach'
    end

    # @!group Validates

    VALID_FABRIC_TYPES = %w(DirectAttach FabricAttach).freeze
    def validate_fabricType(value)
      fail InvalidResource, 'Invalid fabric type' unless VALID_FABRIC_TYPES.include?(value)
    end

    VALID_LINK_STABILITY_TIMES = (1..1800).freeze
    def validate_linkStabilityTime(value)
      return unless @data['fabricType'] && @data['fabricType'] == 'FabricAttach'
      fail InvalidResource, 'Link stability time out of range 1..1800' unless VALID_LINK_STABILITY_TIMES.include?(value)
    end

    # @!endgroup
  end
end
