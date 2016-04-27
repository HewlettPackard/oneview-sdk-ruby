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
  class UplinkSet < Resource
    BASE_URI = '/rest/uplink-sets'.freeze

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

    # @!group Validates

    VALID_ETHERNET_NETWORK_TYPES = %w(NotApplicable Tagged Tunnel Unknown Untagged).freeze
    # Validate ethernetNetworkType
    # @param [String] value NotApplicable, Tagged, Tunnel, Unknown, Untagged
    def validate_ethernetNetworkType(value)
      fail 'Invalid ethernet network type' unless VALID_ETHERNET_NETWORK_TYPES.include?(value)
    end

    VALID_LACP_TIMERS = %w(Short Long).freeze
    # Validate lacpTimer
    # @param [String] value Short, Long
    def validate_lacpTimer(value)
      return if value.to_s.empty?
      fail 'Invalid lacp timer' unless %w(Short Long).include?(value)
    end

    VALID_MANUAL_LOGIN_REDISTRIBUTION_STATES = %w(Distributed Distributing DistributionFailed NotSupported Supported).freeze
    # Validate manualLoginRedistributionState
    # @param [String] value Distributed, Distributing, DistributionFailed, NotSupported, Supported
    def validate_manualLoginRedistributionState(value)
      fail 'Invalid manual login redistribution state' unless VALID_MANUAL_LOGIN_REDISTRIBUTION_STATES.include?(value)
    end

    VALID_NETWORK_TYPES = %w(Ethernet FibreChannel).freeze
    # Validate networkType
    # @param [String] value Ethernet, FibreChannel
    def validate_networkType(value)
      fail 'Invalid network type' unless VALID_NETWORK_TYPES.include?(value)
    end

    VALID_LOCATION_ENTRIES_TYPES = %w(Bay Enclosure Ip Password Port StackingDomainId StackingMemberId UserId).freeze
    # Validate locationEntriesType
    # @param [String] value Bay Enclosure Ip Password Port StackingDomainId StackingMemberId UserId
    def validate_locationEntriesType(value)
      fail 'Invalid location entry type' unless VALID_LOCATION_ENTRIES_TYPES.include?(value)
    end

    VALID_REACHABILITIES = ['NotReachable', 'Reachable', 'RedundantlyReachable', 'Unknown', nil].freeze
    # Validate ethernetNetworkType request
    # @param [String] value NotReachable Reachable RedundantlyReachable Unknown
    def validate_reachability(value)
      fail 'Invalid reachability' unless VALID_REACHABILITIES.include?(value)
    end

    VALID_STATUSES = %w(OK Disabled Warning Critical Unknown).freeze
    # Validate ethernetNetworkType request
    # @param [String] value OK Disabled Warning Critical Unknown
    def validate_status(value)
      fail 'Invalid status' unless VALID_STATUSES.include?(value)
    end

    # @!endgroup

    # Add portConfigInfos to the array
    # @param [String] portUri
    # @param [String] desiredSpeed
    # @param [Hash] locationEntries
    def add_port_config(portUri, speed, locationEntries)
      entry = {
        'portUri' => portUri,
        'desiredSpeed' => speed,
        'location' => {
          'locationEntries' => locationEntries
        }
      }
      @data['portConfigInfos'] << entry
    end

    # Set logical interconnect uri
    # @param [OneviewSDK::LogicalInterconnect, Hash] logical_interconnect
    def set_logical_interconnect(logical_interconnect)
      uri = logical_interconnect[:uri] || logical_interconnect['uri']
      fail 'Invalid object' unless uri
      @data['logicalInterconnectUri'] = uri
    end

    # Add an uri to networkUris array
    # @param [OneviewSDK::EthernetNetwork, Hash] network
    def add_network(network)
      uri = network[:uri] || network['uri']
      fail 'Invalid object' unless uri
      @data['networkUris'].push(uri)
    end

    # Add an uri to fcnetworkUris array
    # @param [OneviewSDK::FCNetwork, Hash] network must accept hash syntax
    def add_fcnetwork(network)
      uri = network[:uri] || network['uri']
      fail 'Invalid object' unless uri
      @data['fcNetworkUris'].push(uri)
    end

    # Add an uri to fcoenetworkUris array
    # @param [OneviewSDK::FCoENetwork, Hash] network must accept hash syntax
    def add_fcoenetwork(network)
      uri = network[:uri] || network['uri']
      fail 'Invalid object' unless uri
      @data['fcoeNetworkUris'].push(uri)
    end

  end
end
