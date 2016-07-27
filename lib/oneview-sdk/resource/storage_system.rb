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
  # Storage system resource implementation
  class StorageSystem < Resource
    BASE_URI = '/rest/storage-systems'.freeze

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
      @data['type'] ||= 'StorageSystemV3'
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def create
      unavailable_method
    end

    # Method is not available
    # @raise [OneviewSDK::MethodUnavailable] method is not available
    def delete
      unavailable_method
    end

    # Adds the resource to OneView using the current data
    # @note Calls the refresh method to set additional data
    # @return [OneviewSDK::StorageSystem] self
    def add
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

    # Checks if the resource already exists
    # @note name,uri or ip_hostname must be specified inside resource
    # @return [Boolean] Whether or not resource exists
    def exists?
      ip_hostname = self['credentials'][:ip_hostname] || self['credentials']['ip_hostname'] if self['credentials']
      return true if @data['name'] && self.class.find_by(@client, name: @data['name']).size == 1
      return true if @data['uri']  && self.class.find_by(@client, uri:  @data['uri']).size == 1
      return true if ip_hostname && self.class.find_by(@client, credentials: { ip_hostname: ip_hostname }).size == 1
      unless @data['name'] || @data['uri'] || ip_hostname
        fail IncompleteResource, 'Must set resource name, uri or ip_hostname before trying to retrieve!'
      end
      false
    end

    # Retrieves the resource details based on this resource's name or URI.
    # @note Name,URI or ip_hostname must be specified inside resource
    # @return [Boolean] Whether or not retrieve was successful
    # @raise [OneviewSDK::IncompleteResource] if attributes are not filled
    def retrieve!
      ip_hostname = self['credentials'][:ip_hostname] || self['credentials']['ip_hostname'] if self['credentials']
      return super if @data['name'] || @data['uri']

      fail IncompleteResource, 'Must set resource name, uri or ip_hostname before trying to retrieve!' unless ip_hostname
      results = self.class.find_by(@client, credentials: { ip_hostname: ip_hostname })
      return false unless results.size == 1
      set_all(results[0].data)
      true
    end

    # Gets the host types for the storage system resource
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @return [String] response body
    def self.get_host_types(client)
      response = client.rest_get(BASE_URI + '/host-types')
      response.body
    end

    # Lists the storage pools
    def get_storage_pools
      response = @client.rest_get(@data['uri'] + '/storage-pools')
      response.body
    end

    # Lists all managed target ports for the specified storage system,
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
