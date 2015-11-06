module OneviewSDK
  # Resource for fcoe networks
  # Common Data Attributes:
  #   category
  #   connectionTemplateUri (required to be nil)
  #   created
  #   description
  #   eTag
  #   ethernetNetworkType
  #   fabricUri
  #   managedSanUri
  #   modified
  #   name (Required)
  #   state
  #   status
  #   type (Required to be 'fcoe-network')
  #   uri
  #   vlanId (Required)
  class FCoENetwork < Resource
    BASE_URI = '/rest/fcoe-networks'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['connectionTemplateUri'] ||= nil
      @data['type'] ||= 'fcoe-network'
    end

    # Validate type
    # @param [String] value fcoe-network
    def validate_type(value)
      fail 'Invalid type' unless %w(fcoe-network).include?(value)
    end

    # Validate vlanId
    # @param [Fixnum] value 1..4094
    def validate_vlanId(value)
      fail 'Invalid network type' unless value.between?(1, 4094)
    end

    # Validate status
    # @param [String] value OK, Disabled, Warning, Critical, Unknown
    def validate_status(value)
      fail 'Invalid ethernet status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

  end
end
