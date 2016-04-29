module OneviewSDK
  # Volume snapshot resource implementation
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

    # Sets the volume
    # @param [OneviewSDK::Volume] volume Volume
    def set_volume(volume)
      fail 'Please set the volume\'s uri attribute!' unless volume['uri']
      @data['storageVolumeUri'] = volume['uri']
    end
  end
end
