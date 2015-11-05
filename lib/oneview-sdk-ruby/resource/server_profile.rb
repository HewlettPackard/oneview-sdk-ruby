
module OneviewSDK
  # Resource for server profiles
  # Common Data Attributes:
  #   affinity
  #   bios
  #   boot
  #   category
  #   connections
  #   description
  #   enclosureBay
  #   enclosureGroupUri (Required)
  #   enclosureUri
  #   eTag
  #   firmware
  #   hideUnusedFlexNics
  #   inProgress
  #   localStorage
  #   macType
  #   name (Required)
  #   sanStorage
  #   serialNumber
  #   serialNumberType
  #   serverHardwareTypeUri (Required)
  #   serverHardwareUri
  #   state
  #   status
  #   taskUri
  #   type (Required)
  #   uuid
  #   wwnType
  class ServerProfile < Resource
    BASE_URI = '/rest/server-profiles'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      case @api_version
      when 120
        @data['type'] ||= 'ServerProfileV4'
      when 200
        @data['type'] ||= 'ServerProfileV5'
      end
    end

    def validate_serverProfileTemplateUri(*)
      fail "Templates only exist on api version >= 200. Resource version: #{@api_version}" if @api_version < 200
    end

    def validate_templateCompliance(*)
      fail "Templates only exist on api version >= 200. Resource version: #{@api_version}" if @api_version < 200
    end

    # Get available server hardware for this template
    # @return [Array<ServerHardware>] Array of ServerHardware that matches this profile's
    #   server hardware type and enclosure group and who's state is 'NoProfileApplied'
    def available_hardware
      ensure_client
      fail 'Must set @data[\'serverHardwareTypeUri\']' unless @data['serverHardwareTypeUri']
      fail 'Must set @data[\'enclosureGroupUri\']' unless @data['enclosureGroupUri']
      params = "filter=\"serverHardwareTypeUri='#{@data['serverHardwareTypeUri']}'"
      params += "&serverGroupUri='#{@data['enclosureGroupUri']}'"
      params += "&state='NoProfileApplied'\""
      hw = @client.rest_get("/rest/server-hardware?#{params}")['members'] || []
      hw.delete_if do |m|
        m['state'] != 'NoProfileApplied' ||
        m['serverHardwareTypeUri'] != @data['serverHardwareTypeUri'] ||
        m['serverGroupUri'] != @data['enclosureGroupUri']
      end
      # TODO: Convert these to ServerHardware objects
      hw
    rescue StandardError => e
      @logger.error "Failed to get available hardware. Message: #{e.message}"
    end

  end
end
