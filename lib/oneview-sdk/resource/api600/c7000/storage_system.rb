# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api300/c7000/storage_system'

module OneviewSDK
  module API600
    module C7000
      # Storage System resource implementation for API600 C7000
      class StorageSystem < OneviewSDK::API300::C7000::StorageSystem
        # deviceSpecificAttributes['serialNumber'] and deviceSpecificAttributes['wwn'] are supported too
        UNIQUE_IDENTIFIERS = %w[name uri hostname].freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          # Default values:
          @data ||= {}
          @data['type'] ||= 'StorageSystemV4'
          super
        end

        # Method is unavailable
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def get_managed_ports(*)
          unavailable_method
        end

        # Method is unavailable
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_refresh_state(*)
          unavailable_method
        end

        # Adds the resource to OneView using the current data
        # @note Calls the refresh method to set additional data
        # @return [OneviewSDK::StorageSystem] self
        def add
          ensure_client
          temp_old_data = JSON.parse(@data.to_json)
          credentials = temp_old_data['credentials'] || {}
          request_body = {
            'family'   => @data['family'],
            'hostname' => @data['hostname'],
            'username' => @data.delete('username') || credentials['username'],
            'password' => @data.delete('password') || credentials['password']
          }
          response = @client.rest_post(self.class::BASE_URI, { 'body' => request_body }, @api_version)
          response_body = @client.response_handler(response)
          set_all(response_body)

          managed_domain = temp_old_data['deviceSpecificAttributes']['managedDomain'] rescue nil
          if self['family'] == 'StoreServ' && managed_domain
            deep_merge!(temp_old_data)
            update
          end
          self
        end

        # Set data and save to OneView
        # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        # @raise [StandardError] if the resource save fails
        # @return [Resource] self
        def update(attributes = {})
          set_all(attributes)
          ensure_client && ensure_uri
          response = @client.rest_put(@data['uri'] + '/?force=true', { 'body' => @data }, @api_version)
          @client.response_handler(response)
          self
        end

        # Delete resource from OneView
        # @return [true] if resource was deleted successfully
        def remove
          ensure_client && ensure_uri
          response = @client.rest_delete(@data['uri'], { 'If-Match' => @data['eTag'] }, @api_version)
          @client.response_handler(response)
          true
        end

        # Checks if the resource already exists
        # @return [Boolean] Whether or not resource exists
        # @raise [OneviewSDK::IncompleteResource] if required attributes are not filled
        def exists?
          temp_item = self.class.new(@client, @data.clone)
          temp_item.retrieve!
        end

        # Retrieves the resource details based on this resource's unique identifiers
        # @note one of the UNIQUE_IDENTIFIERS, deviceSpecificAttributes['serialNumber'] or deviceSpecificAttributes['wwn']
        #     must be specified in the resource
        # @return [Boolean] Whether or not retrieve was successful
        # @raise [OneviewSDK::IncompleteResource] if required attributes are not filled
        def retrieve!
          data_temp = JSON.parse(@data.to_json)
          serial_number = data_temp['deviceSpecificAttributes']['serialNumber'] rescue nil
          wwn = data_temp['deviceSpecificAttributes']['wwn'] rescue nil

          proc_retrieve_temp = proc do |identifier|
            results = self.class.find_by(@client, identifier)
            if results.size == 1
              set_all(results.first.data)
              return true
            end
          end
          proc_retrieve_temp.call('deviceSpecificAttributes' => { 'serialNumber' => serial_number }) if serial_number
          proc_retrieve_temp.call('deviceSpecificAttributes' => { 'wwn' => wwn }) if wwn

          super
        rescue IncompleteResource => e
          raise e unless serial_number || wwn
          false
        end

        # Gets the storage ports that are connected on the specified networks based on the storage system port's expected network connectivity
        # @param [Array] network Array of networks
        # @return [Array] Array of reachable storage port
        def get_reachable_ports(networks = [])
          ensure_client && ensure_uri
          uri = @data['uri'] + '/reachable-ports'
          unless networks.empty?
            network_uris = ensure_and_get_uris(networks)
            uri += "?networks='#{network_uris.join(',')}'"
          end
          self.class.find_with_pagination(@client, uri)
        end

        # Gets a list of storage templates.
        # @return [Array] Array of Storage Template
        def get_templates
          ensure_client && ensure_uri
          self.class.find_with_pagination(@client, @data['uri'] + '/templates')
        end

        # Refreshes a storage system
        def request_refresh
          @data['requestingRefresh'] = true
          update
        end
      end
    end
  end
end
