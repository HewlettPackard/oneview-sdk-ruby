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
  # Storage pool resource implementation
  class StoragePool < Resource
    BASE_URI = '/rest/storage-pools'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'StoragePoolV2'
    end

    # @!group Validates

    VALID_REFRESH_STATES = %w(NotRefreshing RefreshFailed RefreshPending Refreshing).freeze
    # Validate refreshState
    # @param [String] value NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    def validate_refreshState(value)
      fail 'Invalid refresh state' unless VALID_REFRESH_STATES.include?(value)
    end

    VALID_STATUSES = %w(OK Disabled Warning Critical Unknown).freeze
    # Validate status
    # @param [String] value OK, Disabled, Warning, Critical, Unknown
    def validate_status(value)
      fail 'Invalid status' unless VALID_STATUSES.include?(value)
    end

    # @!endgroup

    # Set storage system
    # @param [StorageSystem] storage_system
    def set_storage_system(storage_system)
      set('storageSystemUri', storage_system['uri'])
    end

    def update
      unavailable_method
    end

  end
end
