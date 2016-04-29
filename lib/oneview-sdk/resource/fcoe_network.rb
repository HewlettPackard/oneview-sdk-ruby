module OneviewSDK
  # FCoE network resource implementation
  class FCoENetwork < Resource
    BASE_URI = '/rest/fcoe-networks'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['connectionTemplateUri'] ||= nil
      @data['type'] ||= 'fcoe-network'
    end

    # @!group Validates

    VALID_VLAN_IDS = (1..4094).freeze
    # Validate vlanId
    # @param [Fixnum] value 1..4094
    def validate_vlanId(value)
      fail 'vlanId out of range 1..4094' unless VALID_VLAN_IDS.include?(value)
    end

    # @!endgroup

  end
end
