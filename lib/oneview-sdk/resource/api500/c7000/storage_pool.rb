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
  module API500
    module C7000
      # Storage pool resource implementation for API500 C7000
      class StoragePool < OneviewSDK::API500::C7000::Resource
        BASE_URI = '/rest/storage-pools'.freeze

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
        def delete(*)
          unavailable_method
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
        # @note Storage Pool that belongs to Storage System family StoreVirtual can't be changed to unmanaged
        def manage(be_managed)
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
      end
    end
  end
end
