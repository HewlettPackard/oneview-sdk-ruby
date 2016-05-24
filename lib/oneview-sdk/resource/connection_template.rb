module OneviewSDK
  # Connection template resource implementation
  class ConnectionTemplate < Resource
    BASE_URI = '/rest/connection-templates'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['bandwidth'] ||= {}
      @data['type'] ||= 'connection-template'
    end

    # unavailable method
    def create
      unavailable_method
    end

    # unavailable method
    def delete
      unavailable_method
    end

    # Get the default network connection template
    # @param [OneviewSDK::Client] client Oneview client
    # @return [OneviewSDK::ConnectionTemplate] Connection template
    def self.get_default(client)
      response = client.rest_get(BASE_URI + '/defaultConnectionTemplate')
      OneviewSDK::ConnectionTemplate.new(client, client.response_handler(response))
    end

  end
end
