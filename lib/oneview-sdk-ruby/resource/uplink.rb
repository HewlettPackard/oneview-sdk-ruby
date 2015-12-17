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

    def validate_ethernetNetworkType(value)
      fail 'Invalid ethernet network type' unless %w(NotApplicable Tagged Tunnel Unknown Untagged).include?(value)
    end

    def validate_lacpTimer(value)
      fail 'Invalid lacp timer' unless %w(Short Long).include?(value)
    end

    def validate_manualLoginRedistributionState(value)
      values = %w(Distributed Distributing DistributionFailed NotSupported Supported)
      fail 'Invalid manual login redistribution state' unless values.include?(value)
    end

    def validate_networkType(value)
      fail 'Invalid network type' unless %w(Ethernet FibreChannel).include?(value)
    end

    def validate_locationEntriesType(value)
      values = %w(Bay Enclosure Ip Password Port StackingDomainId StackingMemberId UserId)
      fail 'Invalid location entry type' unless values.include?(value)
    end

    def validate_reachability(value)
      values = %w(NotReachable Reachable RedundantlyReachable Unknown)
      fail 'Invalid reachability' unless values || values.include?(value)
    end

    def validate_status(value)
      fail 'Invalid status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

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

    def set_logical_interconnect(logical_interconnect)
      @data['logicalInterconnectUri'] = logical_interconnect[:uri]
    end

    def set_networks(networks)
      networks.each do |network|
        @data['networkUris'].push(network[:uri])
      end
    end

    def set_fcnetworks(networks)
      networks.each do |network|
        @data['fcNetworkUris'].push(network[:uri])
      end
    end

    def set_fcoenetworks(networks)
      networks.each do |network|
        @data['fcoeNetworkUris'].push(network[:uri])
      end
    end

  end
end
