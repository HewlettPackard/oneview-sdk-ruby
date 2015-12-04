module OneviewSDK
  # Resource for fcoe networks
  # Common Data Attributes:
  #   category
  #   connectionTemplateUri (Required. nil on creation)
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
  #   type (Required)
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

    # Validate vlanId
    # @param [Fixnum] value 1..4094
    def validate_vlanId(value)
      fail 'vlanId out of range 1..4094' unless value.between?(1, 4094)
    end

  end
end
