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

require_relative 'resource'

module OneviewSDK
  module API600
    module C7000
      # Storage pool resource implementation for API600 C7000
      class StoragePool < OneviewSDK::API600::C7000::Resource
        BASE_URI = '/rest/storage-pools'.freeze
        UNIQUE_IDENTIFIERS = %w[uri].freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          # Default values:
          @data['type'] ||= 'StoragePoolV3'
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def create(*)
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def create!(*)
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def delete(*)
          unavailable_method
        end

        # Retrieve resource details based on this resource's name or URI.
        # @note Name or URI must be specified inside the resource
        # @return [Boolean] Whether or not retrieve was successful
        def retrieve!
          return super if @data['uri']
          unless @data['name'] && @data['storageSystemUri']
            raise IncompleteResource, 'Must set resource name and storageSystemUri, or uri, before trying to retrieve!'
          end
          results = self.class.find_by(@client, name: @data['name'], storageSystemUri: @data['storageSystemUri'])
          if results.size == 1
            set_all(results[0].data)
            return true
          end
          false
        end

        # Check if a resource exists
        # @note name or uri must be specified inside resource
        # @return [Boolean] Whether or not resource exists
        def exists?
          temp = self.class.new(@client, data)
          temp.retrieve!
        end

        # Gets the storage pools that are connected on the specified networks based on the storage system port's expected network connectivity.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Array<Resource>] networks The list of networks with URI to be used as a filter
        # @return [Array<OneviewSDK::StoragePool>] the list of storage pools
        def self.reachable(client, networks = [])
          uri = self::BASE_URI + '/reachable-storage-pools'
          unless networks.empty?
            network_uris = networks.map { |item| item['uri'] }
            uri += "?networks='#{network_uris.join(',')}'"
          end
          find_with_pagination(client, uri)
        end

        # To manage/unmanage a storage pool
        # @param [Boolean] be_managed Set true to manage or false to unmanage
        # @note Storage Pool that belongs to Storage System with family StoreVirtual can't be changed to unmanaged
        def manage(be_managed)
          if !be_managed && self['family'] == 'StoreVirtual'
            raise ArgumentError, 'Attempting to unmanage a StoreVirtual pool is not allowed'
          end
          self['isManaged'] = be_managed
          update
          refresh
        end

        # To request a refresh of a storage pool
        def request_refresh
          self['requestingRefresh'] = true
          update
          refresh
        end

        # Sets the storage system
        # @param [OneviewSDK::StorageSystem] storage_system
        # @raise [OneviewSDK::IncompleteResource] if Storage System not found
        def set_storage_system(storage_system)
          raise 'Storage System could not be found!' unless storage_system.retrieve!
          set('storageSystemUri', storage_system['uri'])
        end
      end
    end
  end
end
