module OneviewSDK
  # Firmware driver resource implementation
  class FirmwareDriver < Resource
    BASE_URI = '/rest/firmware-drivers'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'firmware-baselines'
    end

    def create
      fail 'Method not available for this resource!'
    end

    def update
      create
    end

  end
end
