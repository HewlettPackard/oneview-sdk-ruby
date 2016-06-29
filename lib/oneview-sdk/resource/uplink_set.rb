# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewSDK
  # Uplink set resource implementation
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
      fail InvalidResource, 'Invalid ethernet network type' unless VALID_ETHERNET_NETWORK_TYPES.include?(value)
    end

    VALID_LACP_TIMERS = %w(Short Long).freeze
    # Validate lacpTimer
    # @param [String] value Short, Long
    def validate_lacpTimer(value)
      return if value.to_s.empty?
      fail InvalidResource, 'Invalid lacp timer' unless VALID_LACP_TIMERS.include?(value)
    end

    VALID_MANUAL_LOGIN_REDISTRIBUTION_STATES = %w(Distributed Distributing DistributionFailed NotSupported Supported).freeze
    # Validate manualLoginRedistributionState
    # @param [String] value Distributed, Distributing, DistributionFailed, NotSupported, Supported
    def validate_manualLoginRedistributionState(value)
      fail InvalidResource, 'Invalid manual login redistribution state' unless VALID_MANUAL_LOGIN_REDISTRIBUTION_STATES.include?(value)
    end

    VALID_NETWORK_TYPES = %w(Ethernet FibreChannel).freeze
    # Validate networkType
    # @param [String] value Ethernet, FibreChannel
    def validate_networkType(value)
      fail InvalidResource, 'Invalid network type' unless VALID_NETWORK_TYPES.include?(value)
    end

    VALID_LOCATION_ENTRIES_TYPES = %w(Bay Enclosure Ip Password Port StackingDomainId StackingMemberId UserId).freeze
    # Validate locationEntriesType
    # @param [String] value Bay Enclosure Ip Password Port StackingDomainId StackingMemberId UserId
    def validate_locationEntriesType(value)
      fail InvalidResource, 'Invalid location entry type' unless VALID_LOCATION_ENTRIES_TYPES.include?(value)
    end

    VALID_REACHABILITIES = ['NotReachable', 'Reachable', 'RedundantlyReachable', 'Unknown', nil].freeze
    # Validate ethernetNetworkType request
    # @param [String] value NotReachable Reachable RedundantlyReachable Unknown
    def validate_reachability(value)
      fail InvalidResource, 'Invalid reachability' unless VALID_REACHABILITIES.include?(value)
    end

    VALID_STATUSES = %w(OK Disabled Warning Critical Unknown).freeze
    # Validate ethernetNetworkType request
    # @param [String] value OK Disabled Warning Critical Unknown
    def validate_status(value)
      fail InvalidResource, 'Invalid status' unless VALID_STATUSES.include?(value)
    end

    # @!endgroup

    # Add portConfigInfos to the array
    # @param [String] portUri
    # @param [String] speed
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
      fail IncompleteResource, 'Invalid object' unless uri
      @data['logicalInterconnectUri'] = uri
    end

    # Add an uri to networkUris array
    # @param [OneviewSDK::EthernetNetwork, Hash] network
    def add_network(network)
      uri = network[:uri] || network['uri']
      fail IncompleteResource, 'Must set network uri attribute' unless uri
      @data['networkUris'].push(uri)
    end

    # Add an uri to fcnetworkUris array
    # @param [OneviewSDK::FCNetwork, Hash] network must accept hash syntax
    def add_fcnetwork(network)
      uri = network[:uri] || network['uri']
      fail IncompleteResource, 'Must set network uri attribute' unless uri
      @data['fcNetworkUris'].push(uri)
    end

    # Add an uri to fcoenetworkUris array
    # @param [OneviewSDK::FCoENetwork, Hash] network must accept hash syntax
    def add_fcoenetwork(network)
      uri = network[:uri] || network['uri']
      fail IncompleteResource, 'Must set network uri attribute' unless uri
      @data['fcoeNetworkUris'].push(uri)
    end

  end
end
