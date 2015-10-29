
module OneviewSDK
  # Resource for ethernet networks
  class FCNetwork < Resource
    BASE_URI = '/rest/fc-networks'

    attr_accessor \
      :autoLoginRedistribution,
      :category,
      :connectionTemplateUri,
      :created,
      :description,
      :eTag,
      :fabricType,
      :linkStabilityTime,
      :managedSunUri,
      :modified,
      :name,
      :state,
      :status,
      :type,
      :uri

    def initialize(client, params = {}, api_ver = nil)
      # Default values
      @autoLoginRedistribution = false
      @type = 'fc-networkV2'
      @linkStabilityTime = 30
      @fabricType = 'FabricAttach'
      super
    end

    def fabricType=(value)
      if %w(DirectAttach FabricAttach).include?(value)
        @fabricType = value
      else
        fail 'Invalid fabricType value'
      end
    end

    def linkStabilityTime=(value)
      if value.between?(1, 1800)
        @linkStabilityTime = value
      else
        fail 'linkStabilityTime out of range 1..1800'
      end
    end

  end
end
