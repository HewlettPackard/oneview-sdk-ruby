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
      if @api_version < 200 || client.max_api_version < 200
        fail "Snapshots only exist on api version >= 200. Resource version: #{@api_version}"
      end
      @data['type'] ||= 'Snapshot'
    end

    def create
      fail 'Method not available for this resource!'
    end

    def update
      create
    end

    def save
      create
    end

    # Sets the volume
    # @param [OneviewSDK::Volume] Volume
    def set_volume(volume)
      fail 'Please set the volume\'s uri attribute!' unless volume['uri']
      @data['storageVolumeUri'] = volume['uri']
    end
  end
end
