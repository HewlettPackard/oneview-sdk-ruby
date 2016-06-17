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
  # Network set resource implementation
  class NetworkSet < Resource
    BASE_URI = '/rest/network-sets'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['connectionTemplateUri'] ||= nil
      @data['nativeNetworkUri'] ||= nil
      @data['networkUris'] ||= []
      @data['type'] ||= 'network-set'
    end

    # Set native network for the network set
    # @param [OneviewSDK::EthernetNetwork] ethernet_network Ethernet Network
    def set_native_network(ethernet_network)
      @data['nativeNetworkUri'] = ethernet_network['uri']
      @data['networkUris'] << ethernet_network['uri'] unless @data['networkUris'].include?(ethernet_network['uri'])
    end

    # Add an ethernet network to Network Set
    # @param [OneviewSDK::EthernetNetwork] ethernet_network Ethernet Network
    def add_ethernet_network(ethernet_network)
      @data['networkUris'] << ethernet_network['uri'] unless @data['networkUris'].include?(ethernet_network['uri'])
    end

    # Remove an ethernet network from the Network Set
    # @param [OneviewSDK::EthernetNetwork] ethernet_network Ethernet Network
    def remove_ethernet_network(ethernet_network)
      @data['networkUris'].delete(ethernet_network['uri']) if @data['networkUris'].include?(ethernet_network['uri'])
    end

    # List of network sets excluding Ethernet Networks
    # @param [OneviewSDK::Client] client OneviewSDK client
    # @return [Array] List of network sets
    def self.get_without_ethernet(client)
      response = client.rest_get(BASE_URI + '/withoutEthernet')
      client.response_handler(response)
    end

    # Network set excluding Ethernet networks
    # @return [OneviewSDK::NetworkSet] Network set
    def get_without_ethernet
      response = @client.rest_get(@data['uri'] + '/withoutEthernet')
      @client.response_handler(response)
    end

  end
end
