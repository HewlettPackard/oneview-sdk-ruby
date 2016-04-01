module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   category
  #   connectionTemplateUri
  #   created
  #   description
  #   eTag
  #   ethernetNetworkType
  #   fabricUri
  #   modified
  #   name (Required)
  #   privateNetwork (Required)
  #   purpose (Required)
  #   smartLink (Required)
  #   state
  #   status
  #   type (Required)
  #   vlanId (Required)
  class EthernetNetwork < Resource
    BASE_URI = '/rest/ethernet-networks'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['ethernetNetworkType'] ||= 'Tagged'
      case @api_version
      when 120
        @data['type'] ||= 'ethernet-networkV2'
      when 200
        @data['type'] ||= 'ethernet-networkV3'
      end
    end

    # Get associatedProfiles
    def get_associated_profiles
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/associatedProfiles", @api_version)
      response.body
    end

    # Get associatedUplinkGroups
    def get_associated_uplink_groups
      ensure_client && ensure_uri
      response = @client.rest_get("#{@data['uri']}/associatedUplinkGroups", @api_version)
      response.body
    end

    # Validate ethernetNetworkType
    # @param [String] value Notapplicable, Tagged, Tunnel, Unknown, Untagged
    VALID_NETWORK_TYPES = %w(NotApplicable Tagged Tunnel Unknown Untagged)
    def validate_ethernetNetworkType(value)
      fail 'Invalid network type' unless VALID_NETWORK_TYPES.include?(value)
    end

    # Validate purpose
    # @param [String] value FaultTolerance, General, Management, VMMigration
    VALID_PURPOSES = %w(FaultTolerance General Management VMMigration)
    def validate_purpose(value)
      fail 'Invalid ethernet purpose' unless VALID_PURPOSES.include?(value)
    end

  end
end
