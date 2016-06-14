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
  # Server hardware type resource implementation
  class ServerHardwareType < Resource
    BASE_URI = '/rest/server-hardware-types'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'server-hardware-type-4'
    end

    def create
      unavailable_method
    end

    def update(attributes = {})
      set_all(attributes)
      ensure_client && ensure_uri
      data = @data.select { |k, _v| %w(name description).include?(k) }
      data['description'] ||= ''
      response = @client.rest_put(@data['uri'], { 'body' => data }, @api_version)
      @client.response_handler(response)
      self
    end

  end
end
