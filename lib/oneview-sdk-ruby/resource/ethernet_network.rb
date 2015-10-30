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

    def validate(params = {})
      fail 'Invalid network type' if params['ethernetNetworkType'] &&
        ! %w(NotApplicable Tagged Tunnel Unknown Untagged).include?(params['ethernetNetworkType'])

      fail 'Invalid ethernet purpose' if params['purpose'] &&
        ! %w(FaultTolerance General Management VMMigration).include?(params['purpose'])
    end

  end
end
