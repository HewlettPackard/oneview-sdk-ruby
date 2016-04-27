module OneviewSDK
  # Resource for storage volume snapshots
  # Common Data Attributes:
  #   capacity
  #   category
  #   description
  #   deviceSnapshotName
  #   name
  #   readOnly
  #   refreshState
  #   snapshotType
  #   state
  #   status
  #   storageVolumeUri
  #   type
  #   uri
  #   wwn
  class VolumeSnapshot < Resource
    BASE_URI = nil

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'Snapshot'
    end

    def create
      unavailable_method
    end

    def update
      unavailable_method
    end

    def save
      unavailable_method
    end

    # Sets the volume
    # @param [OneviewSDK::Volume] Volume
    def set_volume(volume)
      fail 'Please set the volume\'s uri attribute!' unless volume['uri']
      @data['storageVolumeUri'] = volume['uri']
    end
  end
end
