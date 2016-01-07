module OneviewSDK
  # Resource for ethernet networks
  # Common Data Attributes:
  #   bandwidth (Required)
  #   namePrefix (Required)
  #   privateNetwork (Required)
  #   purpose (Required)
  #   smartLink (Required)
  #   type (Required)
  #   vlanIdRange (Required)
  class BulkEthernetNetwork < Resource
    BASE_URI = '/rest/ethernet-networks/bulk'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'bulk-ethernet-network'
    end

    def update
      fail 'Method not available for this resource!'
    end

    def delete
      fail 'Method not available for this resource!'
    end

    def save
      fail 'Method not available for this resource!'
    end



  end
end
