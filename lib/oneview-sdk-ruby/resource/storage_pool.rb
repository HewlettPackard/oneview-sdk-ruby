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
    BASE_URI = '/rest/storage-pools'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'StoragePoolV2'
    end

    # Validate refreshState
    # @param [String] value NotRefreshing, RefreshFailed, RefreshPending, Refreshing
    def validate_refreshState(value)
      fail 'Invalid refresh state' unless %w(NotRefreshing RefreshFailed RefreshPending Refreshing).include?(value)
    end

    # Validate status
    # @param [String] value OK, Disabled, Warning, Critical, Unknown
    def validate_status(value)
      fail 'Invalid status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

  end
end
