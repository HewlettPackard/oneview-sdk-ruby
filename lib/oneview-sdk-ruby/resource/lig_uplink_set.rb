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

    # Add existing network to the network list.
    # Ethernet and FibreChannel networks are allowed.
    # @param [Resource] network resource to be added to the list
    def add_network(network)
      fail 'Resource not retrieved from server' unless network['uri']
      @data['networkUris'] << network['uri']
    end

    # Specify one uplink passing the VC Bay and the port to be attached.
    # @param [Fixnum] bay number to identify the VC
    # @param [String] port to attach the uplink. Allowed D1..D16 and X1..X10
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

    # Set all params
    # @override sets networkType first
    def set_all(params = {})
      params = params.data if params.class <= Resource
      params = Hash[params.map { |(k, v)| [k.to_s, v] }]
      network_type = params.delete('networkType')
      params.each { |key, value| set(key.to_s, value) }
      set('networkType', network_type)
    end

    # Validate ethernetNetworkType request
    # @param [String] value FibreChannel, Ethernet
    def validate_networkType(value)
      fail 'Invalid network type' unless %w(FibreChannel Ethernet).include?(value)
      fail 'Attribute missing' if value == 'Ethernet' && !@data['ethernetNetworkType']
      fail 'Attribute not supported' if value == 'FibreChannel' && @data['ethernetNetworkType']
    end

    # Validate ethernetNetworkType request
    # @param [String] value Notapplicable, Tagged, Tunnel, Unknown, Untagged. Must exist if networkType is 'Ethernet', otherwise shouldn't.
    def validate_ethernetNetworkType(value)
      fail 'Invalid ethernet type' unless %w(NotApplicable Tagged Tunnel Unknown Untagged).include?(value)
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
