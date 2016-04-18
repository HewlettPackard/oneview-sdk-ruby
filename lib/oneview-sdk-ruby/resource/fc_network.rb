module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   autoLoginRedistribution (Required)
  #   category
  #   connectionTemplateUri
  #   created
  #   description
  #   eTag
  #   fabricType (Required)
  #   linkStabilityTime (Required for FabricAttach)
  #   managedSunUri
  #   modified
  #   name (Required)
  #   state
  #   status
  #   type (Required)
  class FCNetwork < Resource
    BASE_URI = '/rest/fc-networks'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['autoLoginRedistribution'] ||= false
      @data['type'] ||= 'fc-networkV2'
      @data['linkStabilityTime'] ||= 30
      @data['fabricType'] ||= 'FabricAttach'
    end

    # @!group Validates

    VALID_FABRIC_TYPES = %w(DirectAttach FabricAttach).freeze
    def validate_fabricType(value)
      fail 'Invalid fabric type' unless VALID_FABRIC_TYPES.include?(value)
    end

    VALID_LINK_STABILITY_TIMES = (1..1800).freeze
    def validate_linkStabilityTime(value)
      return unless @data['fabricType'] && @data['fabricType'] == 'FabricAttach'
      fail 'Link stability time out of range 1..1800' unless VALID_LINK_STABILITY_TIMES.include?(value)
    end

    # @!endgroup

  end
end
