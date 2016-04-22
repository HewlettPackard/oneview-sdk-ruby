module OneviewSDK
  # Resource for server profiles
  # Common Data Attributes:
  #   baselineShortName
  #   bundleSize
  #   category
  #   description
  #   eTag
  #   fwComponents
  #   isoFileName
  #   lastTaskUri
  #   name
  #   releaseDate
  #   resourceId
  #   resourceState
  #   state
  #   status
  #   supportedLanguages
  #   supportedOSList
  #   swPackagesFullPath
  #   type (Required)
  #   uri
  #   uuid
  #   version
  #   xmlKeyName
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

    def save
      create
    end

  end
end
