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

    # Create a resource object, associate it with a client, and set its properties.
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] params The options for this resource (key-value pairs)
    # @param [Integer] api_ver The api version to use when interracting with this resource.
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

    # Adds the portConfigInfos to the array
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

    # Sets the logical interconnect uri
    # @param [OneviewSDK::LogicalInterconnect, Hash] logical_interconnect
    def set_logical_interconnect(logical_interconnect)
      uri = logical_interconnect[:uri] || logical_interconnect['uri']
      fail IncompleteResource, 'Invalid object' unless uri
      @data['logicalInterconnectUri'] = uri
    end

    # Adds an ethernet network to the uplink set
    # @param [OneviewSDK::EthernetNetwork, Hash] network
    def add_network(network)
      uri = network[:uri] || network['uri']
      fail IncompleteResource, 'Must set network uri attribute' unless uri
      @data['networkUris'].push(uri)
    end

    # Adds an fc network to the uplink set
    # @param [OneviewSDK::FCNetwork, Hash] network must accept hash syntax
    def add_fcnetwork(network)
      uri = network[:uri] || network['uri']
      fail IncompleteResource, 'Must set network uri attribute' unless uri
      @data['fcNetworkUris'].push(uri)
    end

    # Adds an fcoe network to the uplink set
    # @param [OneviewSDK::FCoENetwork, Hash] network must accept hash syntax
    def add_fcoenetwork(network)
      uri = network[:uri] || network['uri']
      fail IncompleteResource, 'Must set network uri attribute' unless uri
      @data['fcoeNetworkUris'].push(uri)
    end
  end
end
