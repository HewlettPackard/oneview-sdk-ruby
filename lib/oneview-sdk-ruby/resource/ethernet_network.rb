
module OneviewSDK
  # Resource for ethernet networks
  class EthernetNetwork < Resource
    CREATE_URI = '/ethernetNetworks/new'

    attr_accessor \
      :vlanId,
      :purpose,
      :smartLink,
      :privateNetwork,
      :ethernetNetworkType,
      :type,
      :connectionTemplateUri

    def initialize(params, client = nil, api_ver = OneviewSDK::Client::DEFAULT_API_VERSION)
      super(params, client, api_ver)
      # Do other custom things here if necessary
    end

  end
end
