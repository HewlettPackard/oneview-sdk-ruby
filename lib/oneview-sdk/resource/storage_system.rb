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
  # Storage system resource implementation
  class StorageSystem < Resource
    BASE_URI = '/rest/storage-systems'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'StorageSystemV3'
    end

    def create
      ensure_client
      task = @client.rest_post(self.class::BASE_URI, { 'body' => self['credentials'] }, @api_version)
      temp = @data.clone
      task = @client.wait_for(task['uri'] || task['location'])
      @data['uri'] = task['associatedResource']['resourceUri']
      refresh
      temp.delete('credentials')
      update(temp)
      self
    end

    def retrieve!
      if @data['name']
        super
      else
        ip_hostname = self['credentials'][:ip_hostname] || self['credentials']['ip_hostname']
        results = self.class.find_by(@client, credentials: { ip_hostname: ip_hostname })
        return false unless results.size == 1
        set_all(results[0].data)
        true
      end
    end

    # Get host types for storage system resource
    # @param [Client] client client handle REST calls to OV instance
    # @return [String] response body
    def self.get_host_types(client)
      response = client.rest_get(BASE_URI + '/host-types')
      response.body
    end

    # List of storage pools
    def get_storage_pools
      response = @client.rest_get(@data['uri'] + '/storage-pools')
      response.body
    end

    # List of all managed target ports for the specified storage system
    # or only the one specified
    # @param [String] port Target port
    def get_managed_ports(port = nil)
      response = if port.nil?
                   @client.rest_get("#{@data['uri']}/managedPorts")
                 else
                   @client.rest_get("#{@data['uri']}/managedPorts/#{port}")
                 end
      response.body
    end

  end
end
