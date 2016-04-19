module OneviewSDK
  # Resource for interconnect types
  class Interconnect < Resource
    BASE_URI = '/rest/interconnects'.freeze
    TYPE_URI = '/rest/interconnect-types'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
    end

    def create
      unavailable_method
    end

    def update
      unavailable_method
    end

    def save
      unavailable_method
    end

    def delete
      unavailable_method
    end

    # Retrieve interconnect types
    # @param [Client] client http client
    def self.get_types(client)
      response = client.rest_get(TYPE_URI)
      response = client.response_handler(response)
      response['members']
    end

    # Retrieve interconnect ype with name
    # @param [Client] client http client
    # @param [String] name Interconnect type name
    # @return [Array] Interconnect type
    def self.get_type(client, name)
      results = types(client)
      results.find { |interconnect_type| interconnect_type['name'] == name }
    end

    # Retrieve named servers for this interconnect
    def name_servers
      response = @client.rest_get(@data['uri'] + '/nameServers')
      response.body
    end

    # Updates an interconnect port
    # @param [String] portName port name
    # @param [Hash] attributes hash with attributes and values to be changed
    def update_port(portName, attributes)
      @data['ports'].each do |port|
        next unless port['name'] == portName
        attributes.each { |key, value| port[key.to_s] = value }
        response = @client.rest_put(@data['uri'] + '/ports', 'body' => port)
        @client.response_handler(response)
      end
    end

    # Get statistics for an interconnect, for the specified port or subport
    # @param [String] portName port to retrieve statistics
    # @param [String] subportNumber subport to retrieve statistics
    def statistics(portName = nil, subportNumber = nil)
      uri = if subportNumber.nil?
              @data['uri'] + '/statistics' + "/#{portName}"
            else
              @data['uri'] + '/statistics' + "/#{portName}" + "/subport/#{subportNumber}"
            end
      response = @client.rest_get(uri)
      response.body
    end

    # Triggers a reset of port protection
    def reset_port_protection
      response = @client.rest_put(@data['uri'] + '/resetportprotection')
      @client.response_handler(response)
    end

    # Update specific attributes of a given interconnect resource
    # @param [String] operation operation to be performed
    # @param [String] path path
    # @param [String] value value
    def update_attribute(operation, path, value)
      response = @client.rest_patch(@data['uri'], 'body' => [{ op: operation, path: path, value: value }])
      @client.response_handler(response)
    end

  end
end
