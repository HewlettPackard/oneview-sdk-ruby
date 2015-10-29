
module OneviewSDK
  # Resource for ethernet networks
  class EthernetNetwork < Resource
    BASE_URI = '/rest/ethernet-networks'

    attr_accessor \
      :category,
      :connectionTemplateUri,
      :created,
      :description,
      :eTag,
      :ethernetNetworkType,
      :fabricUri,
      :modified,
      :name,
      :privateNetwork,
      :purpose,
      :smartLink,
      :state,
      :status,
      :type,
      :uri,
      :vlanId

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
