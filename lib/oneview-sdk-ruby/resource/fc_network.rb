
module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   autoLoginRedistribution
  #   category
  #   connectionTemplateUri
  #   created
  #   description
  #   eTag
  #   fabricType
  #   linkStabilityTime
  #   managedSunUri
  #   modified
  #   name
  #   state
  #   status
  #   type
  #   uri
  class FCNetwork < Resource
    BASE_URI = '/rest/fc-networks'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['autoLoginRedistribution'] ||= false
      @data['type'] ||= 'fc-networkV2'
      @data['linkStabilityTime'] ||= 30
      @data['fabricType'] ||= 'FabricAttach'
    end

    def validate_fabricType(value)
      fail 'Invalid fabric type' unless %w(DirectAttach FabricAttach).include?(value)
    end

    def validate_linkStabilityTime(value)
      fail 'Link stability time out of range 1..1800' unless value.between?(1, 1800)
    end
    
    def validate_status(value)
      fail 'Invalid status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

  end
end
