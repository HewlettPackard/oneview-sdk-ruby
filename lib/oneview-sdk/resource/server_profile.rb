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
    BASE_URI = '/rest/server-profiles'.freeze

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

    # Get available server hardware for this template
    # @return [Array<OneviewSDK::ServerHardware>] Array of ServerHardware resources that matches this
    #   profile's server hardware type and enclosure group and who's state is 'NoProfileApplied'
    def available_hardware
      ensure_client
      fail 'Must set @data[\'serverHardwareTypeUri\']' unless @data['serverHardwareTypeUri']
      fail 'Must set @data[\'enclosureGroupUri\']' unless @data['enclosureGroupUri']
      params = {
        state: 'NoProfileApplied',
        serverHardwareTypeUri: @data['serverHardwareTypeUri'],
        serverGroupUri: @data['enclosureGroupUri']
      }
      OneviewSDK::ServerHardware.find_by(@client, params)
    rescue StandardError => e
      raise "Failed to get available hardware. Message: #{e.message}"
    end

    def validate_serverProfileTemplateUri(*)
      fail "Templates only exist on api version >= 200. Resource version: #{@api_version}" if @api_version < 200
    end

    def validate_templateCompliance(*)
      fail "Templates only exist on api version >= 200. Resource version: #{@api_version}" if @api_version < 200
    end
  end
end
