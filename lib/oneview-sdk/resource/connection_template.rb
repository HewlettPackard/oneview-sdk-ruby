################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

module OneviewSDK
  # Connection template resource implementation
  class ConnectionTemplate < Resource
    BASE_URI = '/rest/connection-templates'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['bandwidth'] ||= {}
      @data['type'] ||= 'connection-template'
    end

    # unavailable method
    def create
      unavailable_method
    end

    # unavailable method
    def delete
      unavailable_method
    end

    # Get the default network connection template
    # @param [OneviewSDK::Client] client Oneview client
    # @return [OneviewSDK::ConnectionTemplate] Connection template
    def self.get_default(client)
      response = client.rest_get(BASE_URI + '/defaultConnectionTemplate')
      OneviewSDK::ConnectionTemplate.new(client, client.response_handler(response))
    end

  end
end
