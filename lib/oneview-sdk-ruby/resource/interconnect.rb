module OneviewSDK
  # Resource for interconnect types
  class Interconnect < Resource
    BASE_URI = '/rest/interconnects'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
    end

    def create
      fail 'Method not available for this resource!'
    end

    def update
      fail 'Method not available for this resource!'
    end

    def save
      fail 'Method not available for this resource!'
    end

    def delete
      fail 'Method not available for this resource!'
    end

    # Retrieve named servers for this interconnect
    def nameServers
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
    def resetportprotection
      response = @client.rest_put(@data['uri'] + '/resetportprotection')
      @client.response_handler(response)
    end

    # Update specific attributes of a given interconnect resource
    # @param [String] operation operation to be performed
    # @param [String] path path
    # @param [String] value value
    def updateAttribute(operation, path, value)
      response = @client.rest_patch(@data['uri'], 'body' => [{ op: operation, path: path, value: value }])
      @client.response_handler(response)
    end

  end
end
