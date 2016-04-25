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
    BASE_URI = '/rest/ethernet-networks/bulk'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'bulk-ethernet-network'
    end

    def create
      ensure_client
      response = @client.rest_post(self.class::BASE_URI, { 'body' => @data }, @api_version)
      @client.response_handler(response)
    end

    def update
      fail 'Method not available for this resource!'
    end

    def save
      update
    end

    def delete
      update
    end

  end
end
