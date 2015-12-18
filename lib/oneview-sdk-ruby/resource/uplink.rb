module OneviewSDK
  # Resource for uplink sets
  # Common Data Attributes:
  #   category
  #   connectionMode
  #   created
  #   description
  #   eTag
  #   ethernetNetworkType
  #   fcNetworkUris
  #   fcoeNetworkUris
  #   lacpTimer
  #   logicalInterconnectUri
  #   manualLoginRedistributionState
  #   modified
  #   name
  #   nativeNetworkUri
  #   networkType
  #   networkUris
  #   portConfigInfos
  #   primaryPortLocation
  #   reachability
  #   state
  #   status
  #   type
  #   uri
  class Uplink < Resource
    BASE_URI = '/rest/uplink-sets'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['fcNetworkUris'] ||= []
      @data['fcoeNetworkUris'] ||= []
      @data['networkUris'] ||= []
      @data['portConfigInfos'] ||= []
      @data['primaryPortLocation'] = nil
      @data['type'] ||= 'uplink-setV3'
    end

    # Validate ethernetNetworkType
    # @param [String] value NotApplicable, Tagged, Tunnel, Unknown, Untagged
    def validate_ethernetNetworkType(value)
      fail 'Invalid ethernet network type' unless %w(NotApplicable Tagged Tunnel Unknown Untagged).include?(value)
    end

    # Validate lacpTimer
    # @param [String] value Short, Long
    def validate_lacpTimer(value)
      fail 'Invalid lacp timer' unless %w(Short Long).include?(value)
    end

    # Validate manualLoginRedistributionState
    # @param [String] value Distributed, Distributing, DistributionFailed, NotSupported, Supported
    def validate_manualLoginRedistributionState(value)
      values = %w(Distributed Distributing DistributionFailed NotSupported Supported)
      fail 'Invalid manual login redistribution state' unless values.include?(value)
    end

    # Validate networkType
    # @param [String] value Ethernet, FibreChannel
    def validate_networkType(value)
      fail 'Invalid network type' unless %w(Ethernet FibreChannel).include?(value)
    end

    # Validate locationEntriesType
    # @param [String] value FibreChannel, Ethernet
    def validate_locationEntriesType(value)
      values = %w(Bay Enclosure Ip Password Port StackingDomainId StackingMemberId UserId)
      fail 'Invalid location entry type' unless values.include?(value)
    end

    # Validate ethernetNetworkType request
    # @param [String] value FibreChannel, Ethernet
    def validate_reachability(value)
      values = %w(NotReachable Reachable RedundantlyReachable Unknown)
      return if value.nil?
      fail 'Invalid reachability' unless values.include?(value)
    end

    # Validate ethernetNetworkType request
    # @param [String] value FibreChannel, Ethernet
    def validate_status(value)
      fail 'Invalid status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

    # Add portConfigInfos to the array
    # @param [String] portUri
    # @param [String] desiredSpeed
    # @param [Hash] locationEntries
    def add_portConfig(portUri, speed, locationEntries)
      entry = {
        portUri: portUri,
        desiredSpeed: speed,
        location: {
          locationEntries: locationEntries
        }
      }
      @data['portConfigInfos'] << entry
    end

    # Set logical interconnect uri
    # @param [Hash] logical_interconnect must accept hash syntax
    def set_logical_interconnect(logical_interconnect)
      fail 'Invalid object' unless logical_interconnect[:uri]
      @data['logicalInterconnectUri'] = logical_interconnect[:uri]
    end

    # Add an uri to networkUris array
    # @param [Hash] network must accept hash syntax
    def add_network(network)
      fail 'Invalid object' unless network[:uri]
      @data['networkUris'].push(network[:uri])
    end

    # Add an uri to fcnetworkUris array
    # @param [Hash] network must accept hash syntax
    def add_fcnetwork(network)
      fail 'Invalid object' unless network[:uri]
      @data['fcNetworkUris'].push(network[:uri])
    end

    # Add an uri to fcoenetworkUris array
    # @param [Hash] network must accept hash syntax
    def add_fcoenetwork(network)
      fail 'Invalid object' unless network[:uri]
      @data['fcoeNetworkUris'].push(network[:uri])
    end

  end
end
