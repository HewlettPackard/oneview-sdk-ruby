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
    BASE_URI = '/rest/ethernet-networks'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['ethernetNetworkType'] ||= 'Tagged'
    end

    def validate_type(value)
      fail 'Invalid type' if value != 'ethernet-networkV3'
    end

    # Validate ethernetNetworkType
    # @param [String] value Notapplicable, Tagged, Tunnel, Unknown, Untagged
    def validate_ethernetNetworkType(value)
      fail 'Invalid network type' unless %w(NotApplicable Tagged Tunnel Unknown Untagged).include?(value)
    end

    # Validate purpose
    # @param [String] value FaultTolerance, General, Management, VMMigration
    def validate_purpose(value)
      fail 'Invalid ethernet purpose' unless %w(FaultTolerance General Management VMMigration).include?(value)
    end

  end
end
