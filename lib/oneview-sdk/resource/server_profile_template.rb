module OneviewSDK
  # Resource for server profile templates
  # Common Data Attributes:
  #   affinity
  #   bios
  #   boot
  #   bootMode
  #   category
  #   connections
  #   description
  #   enclosureGroupUri (Required)
  #   eTag
  #   firmware
  #   localStorage
  #   macType
  #   name (Required)
  #   sanStorage
  #   serialNumberType
  #   serverHardwareTypeUri (Required)
  #   serverProfileDescription
  #   state
  #   status
  #   type (Required)
  #   wwnType
  class ServerProfileTemplate < Resource
    BASE_URI = '/rest/server-profile-templates'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'ServerProfileTemplateV1'
    end

    # Create ServerProfile using this template
    # @param [String] name Name of new server profile
    # @return [ServerProfile] New server profile from template.
    #   Temporary object only; call .create to actually create resource on OneView.
    def new_profile(name = nil)
      ensure_client && ensure_uri
      options = @client.rest_get("#{@data['uri']}/new-profile")
      profile = OneviewSDK::ServerProfile.new(@client, options)
      profile[:name] = name if name && name.size > 0
      profile
    end
  end
end
