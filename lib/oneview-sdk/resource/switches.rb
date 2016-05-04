module OneviewSDK
  # Switch resource implementation
  class Switch < Resource
    BASE_URI = '/rest/switches'.freeze
    TYPE_URI = '/rest/switch-types'.freeze

    def create
      unavailable_method
    end

    def update
      unavailable_method
    end

    def refresh
      unavailable_method
    end

    # Retrieve switch types
    # @param [Client] client http client
    def self.get_types(client)
      response = client.rest_get(TYPE_URI)
      response = client.response_handler(response)
      response['members']
    end

    # Retrieve switch type with name
    # @param [Client] client http client
    # @param [String] name Switch type name
    # @return [Array] Switch type
    def self.get_type(client, name)
      results = get_types(client)
      results.find { |switch_type| switch_type['name'] == name }
    end

    # Get statistics for an interconnect, for the specified port or subport
    # @param [String] portName port to retrieve statistics
    # @param [String] subportNumber subport to retrieve statistics
    def statistics(port_name = nil, subport_number = nil)
      uri = if subport_number
              "#{@data['uri']}/statistics/#{port_name}/subport/#{subport_number}"
            else
              "#{@data['uri']}/statistics/#{port_name}"
            end
      response = @client.rest_get(uri)
      response.body
    end

    # Get settings that describe the environmental configuration
    # @return [Hash] Configurations parameters
    def environmental_configuration
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/environmentalConfiguration', @api_version)
      @client.response_handler(response)
    end

  end
end
