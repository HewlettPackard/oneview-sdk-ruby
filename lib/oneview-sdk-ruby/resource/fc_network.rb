
module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes
  #   autoLoginRedistribution (Required)
  #   category
  #   connectionTemplateUri (Required)
  #   created
  #   description
  #   eTag
  #   fabricType (Required)
  #   linkStabilityTime (Required)
  #   managedSunUri
  #   modified
  #   name
  #   state
  #   status
  #   type (Required)
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


    def validate(params = {})
      # fail "Invalid Fabric type #{params['fabricType']}" unless fabricType(params['fabricType'])
      # fail 'Link stability out of range 1..1800' unless linkStabilityTime(params['linkStabilityTime'])
    end

    private

    def fabricType(value)
      %w(DirectAttach FabricAttach).include?(value)
    end

    def linkStabilityTime(value)
      value.between?(1, 1800)
    end

  end
end
