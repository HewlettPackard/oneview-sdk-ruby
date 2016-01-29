
module OneviewSDK
  # Resource for server hardware types
  # Common Data Attributes:
  #   adapters
  #   biosSettings
  #   bootCapabilities
  #   bootModes
  #   capabilities
  #   category
  #   description
  #   eTag
  #   formFactor
  #   model
  #   name
  #   pxeBootPolicies
  #   storageCapabilities
  #   type
  #   uri
  class ServerHardwareType < Resource
    BASE_URI = '/rest/server-hardware-types'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      case @api_version
      when 120
        @data['type'] ||= 'server-hardware-type-3'
      when 200
        @data['type'] ||= 'server-hardware-type-4'
      end
    end

    def create
      fail 'Method not available for this resource!'
    end

    def save
      ensure_client && ensure_uri
      data = @data.select { |k, _v| %w(name description).include?(k) }
      data['description'] ||= ''
      response = @client.rest_put(@data['uri'], { 'body' => data }, @api_version)
      @client.response_handler(response)
      self
    end

  end
end
