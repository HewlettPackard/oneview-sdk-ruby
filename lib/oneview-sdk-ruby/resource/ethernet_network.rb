
module OneviewSDK
  # Resource for ethernet networks
  class EthernetNetwork < Resource
    BASE_URI = '/rest/ethernet-networks'

    attr_accessor \
      :vlanId,
      :purpose,
      :smartLink,
      :privateNetwork,
      :ethernetNetworkType,
      :type,
      :connectionTemplateUri

  end
end
