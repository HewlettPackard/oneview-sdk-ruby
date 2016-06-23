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
  # Logical Downlink resource implementation
  class LogicalDownlink < Resource
    BASE_URI = '/rest/logical-downlinks'.freeze

    def create
      unavailable_method
    end

    def update
      unavailable_method
    end

    def delete
      unavailable_method
    end

    # Gets a list of logical downlinks, excluding any existing ethernet network
    # @param [OneviewSDK::Client] client HPE OneView client
    # @param [Array<OneviewSDK::LogicalDownlink] Logical Downlink array
    def self.get_without_ethernet(client)
      result = []
      response = client.rest_get(BASE_URI + '/withoutEthernet')
      members = client.response_handler(response)['members']
      members.each { |member| result << new(client, member) }
      result
    end

    # Get a logical downlink excluding any existing ethernet network
    # @return [OneviewSDK::LogicalDownlink] Logical Downlink array
    def get_without_ethernet
      response = @client.rest_get(@data['uri'] + '/withoutEthernet')
      OneviewSDK::LogicalDownlink.new(@client, @client.response_handler(response))
    end

  end
end
