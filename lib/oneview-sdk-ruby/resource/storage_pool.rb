
module OneviewSDK
  # Resource for Storage Pools
  # Common Data Attributes:
  #  allocatedCapacity
  #  capacityLimit
  #  capacityWarningLimit
  #  category
  #  created
  #  description
  #  deviceSpeed
  #  deviceType
  #  domain
  #  eTag
  #  freeCapacity
  #  modified
  #  name
  #  refreshState
  #  state
  #  stateReason
  #  status
  #  storageSystemUri
  #  supportedRAIDLevel
  #  totalCapacity
  #  type
  #  uri
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
