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

require_relative '../../api800/c7000/storage_system'

module OneviewSDK
  module API1200
    module C7000
      # Storage System resource implementation for API1200 C7000
      class StorageSystem < OneviewSDK::API800::C7000::StorageSystem
        # Set data and save to OneView
        # @param [Hash] attributes The attributes to add/change for this resource (key-value pairs)
        # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
        # @raise [StandardError] if the resource save fails
        # @return [Resource] self
        def update(attributes = {})
          set_all(attributes)
          ensure_client && ensure_uri
          @data.delete('type')
          response = @client.rest_put(@data['uri'] + '/?force=true', { 'body' => @data }, @api_version)
          @client.response_handler(response)
          self
        end
      end
    end
  end
end
