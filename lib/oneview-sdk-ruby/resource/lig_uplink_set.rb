module OneviewSDK
  # Resource for Uplink Sets used in Logical interconnect groups
  ### Common Attributes:
  # name
  # networkUris
  # mode
  # lacpTimer
  # networkType ['Ethernet', 'FibreChannel' ]
  # ethernetNetworkType (Required if networkType == 'Ethernet')
  class LIGUplinkSet < Resource
    BASE_URI = '/rest/logical-interconnect-groups'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['logicalPortConfigInfos'] = []
      @data['lacpTimer'] = 'Short'
      @data['mode'] = 'Auto'
      @data['networkUris'] = []
    end

    def add_network(network)
      @data['networkUris'] << network['uri']
    end

    def add_uplink(bay, port)
      entry = {
        'desiredSpeed' => 'Auto',
        'logicalLocation' => {
          'locationEntries' => [
            { 'relativeValue' => bay, 'type' => 'Bay' },
            { 'relativeValue' => 1, 'type' => 'Enclosure' },
            { 'relativeValue' => relative_value_of(port), 'type' => 'Port' }
          ]
        }
      }
      @data['logicalPortConfigInfos'] << entry
    end

    # Validate ethernetNetworkType request
    # @param [String] value Notapplicable, Tagged, Tunnel, Unknown, Untagged. Must exist if networkType is 'Ethernet', otherwise shouldn't.
    def validate_ethernet_network_type(value)
      fail 'Attribute not supported' unless @data['networkType'] == 'Ethernet'
      fail 'Invalid network type' unless %w(NotApplicable Tagged Tunnel Unknown Untagged).include?(value)
    end

    private

    # Relative values:
    #   Downlink Ports: D1 is 1, D2 is 2, ....,D15 is 15, D16 is 16;
    #   Uplink Ports: X1 is 17, X2 is 18, ....,X9 is 25, X10 is 26.
    def relative_value_of(port)
      identifier = port.slice!(0)
      case identifier
      when 'D'
        offset = 0
      when 'X'
        offset = 16
      else
        fail "Port not supported: #{identifier} type not found"
      end
      port.to_i + offset
    end

  end
end
