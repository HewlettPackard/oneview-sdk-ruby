
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
      # Default values
      @ethernetNetworkType = 'Tagged'
      super
    end

    def ethernetNetworkType=(value)
      if %w('NotApplicable Tagged Tunnel Unknown Untagged).include?(value)
        @ethernetNetworkType = value
      else
        fail 'Invalid network type'
      end
    end

    def purpose=(value)
      if %w(FaultTolerance General Management VMMigration).include?(value)
        @purpose = value
      else
        fail 'Invalid ethernet purpose'
      end
    end


  end
end
