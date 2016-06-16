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
      unavailable_method
    end

    def update
      unavailable_method
    end

  end
end
