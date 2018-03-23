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

require_relative '../../api500/c7000/storage_pool'

module OneviewSDK
  module API600
    module C7000
      # Storage pool resource implementation for API600 C7000
      class StoragePool < OneviewSDK::API500::C7000::StoragePool
        # Gets the storage pools that are connected on the specified networks based on the storage system port's expected network connectivity.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Dict<Resource>] query The query parameters to be used as a filter
        # @return [Array<OneviewSDK::StoragePool>] the list of storage pools
        def self.reachable(client, query = nil)
          uri = self::BASE_URI + '/reachable-storage-pools'
          query_uri = build_query(query)
          uri += query_uri
          find_with_pagination(client, uri)
        end
      end
    end
  end
end
