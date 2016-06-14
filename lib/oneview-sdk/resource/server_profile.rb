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
  # Server profile resource implementation
  class ServerProfile < Resource
    BASE_URI = '/rest/server-profiles'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'ServerProfileV5'
    end

    # Get available server hardware for this template
    # @return [Array<OneviewSDK::ServerHardware>] Array of ServerHardware resources that matches this
    #   profile's server hardware type and enclosure group and who's state is 'NoProfileApplied'
    def available_hardware
      ensure_client
      fail 'Must set @data[\'serverHardwareTypeUri\']' unless @data['serverHardwareTypeUri']
      fail 'Must set @data[\'enclosureGroupUri\']' unless @data['enclosureGroupUri']
      params = {
        state: 'NoProfileApplied',
        serverHardwareTypeUri: @data['serverHardwareTypeUri'],
        serverGroupUri: @data['enclosureGroupUri']
      }
      OneviewSDK::ServerHardware.find_by(@client, params)
    rescue StandardError => e
      raise "Failed to get available hardware. Message: #{e.message}"
    end

    def validate_serverProfileTemplateUri(*)
      fail "Templates only exist on api version >= 200. Resource version: #{@api_version}" if @api_version < 200
    end

    def validate_templateCompliance(*)
      fail "Templates only exist on api version >= 200. Resource version: #{@api_version}" if @api_version < 200
    end
  end
end
