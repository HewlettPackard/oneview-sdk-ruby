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

require_relative 'resource'

module OneviewSDK
  module API200
    # Uplink sets resource implementation to be used in logical interconnect groups
    class LIGUplinkSet < Resource
      BASE_URI = '/rest/logical-interconnect-groups'.freeze

      # Create a resource object, associate it with a client, and set its properties.
      # @param [OneviewSDK::Client] client The client object for the OneView appliance
      # @param [Hash] params The options for this resource (key-value pairs)
      # @param [Integer] api_ver The api version to use when interracting with this resource.
      def initialize(client, params = {}, api_ver = nil)
        super
        # Default values:
        @data['logicalPortConfigInfos'] ||= []
        @data['lacpTimer'] ||= 'Short' unless @data['networkType'] == 'FibreChannel' # FibreChannel does not need set up lacpTimer
        @data['mode'] ||= 'Auto'
        @data['networkUris'] ||= []
      end

      # Add an existing network to the network list.
      # Ethernet and FibreChannel networks are allowed.
      # @param [OneviewSDK::Resource] network The resource to be added to the list
      def add_network(network)
        network.retrieve! unless network['uri']
        @data['networkUris'] << network['uri']
      end

      # Specify one uplink passing the virtual connect bay and the port to be attached.
      # @param [Fixnum] bay number to identify the VC
      # @param [String, Fixnum] port to attach the uplink. Examples: X1, D1, Q1, Q1.1, Q1:1, 67 ...
      # @param [String] interconnect model name
      # @param [Fixnum] enclosure number for multi-frame configurations
      def add_uplink(bay, port, type = nil, enclosure_index = 1)
        enclosure_index = type && type.include?('Virtual Connect SE 16Gb FC Module for Synergy') ? -1 : enclosure_index
        port = if type
                 fetch_relative_value_of(port, type)
               else
                 # Detect Integer port: for example 67 or '67'
                 port.to_s == port.to_i.to_s ? port.to_i : relative_value_of(port)
               end

        entry = {
          'desiredSpeed' => 'Auto',
          'logicalLocation' => {
            'locationEntries' => [
              { 'relativeValue' => bay, 'type' => 'Bay' },
              { 'relativeValue' => enclosure_index, 'type' => 'Enclosure' },
              { 'relativeValue' => port, 'type' => 'Port' }
            ]
          }
        }
        @data['logicalPortConfigInfos'] << entry
      end

      # Sets all params
      # @overload sets networkType first
      def set_all(params = {})
        params = params.data if params.class <= Resource
        params = Hash[params.map { |(k, v)| [k.to_s, v] }]
        network_type = params.delete('networkType')
        params.each { |key, value| set(key.to_s, value) }
        set('networkType', network_type) if network_type
      end

      private

      # Relative values:
      #   Downlink Ports: D1 is 1, D2 is 2, ....,D15 is 15, D16 is 16;
      #   Uplink Ports: X1 is 17, X2 is 18, ....,X9 is 25, X10 is 26.
      def relative_value_of(port)
        identifier = port.slice!(0)
        offset = case identifier
                 when 'D' then 0
                 when 'X' then 16
                 else raise InvalidResource, "Port not supported: #{identifier} type not found"
                 end
        port.to_i + offset
      end

      def fetch_relative_value_of(port, type)
        port_formats = [port.sub('.', ':'), port.sub(':', '.')].uniq
        interconnect_type = OneviewSDK::Interconnect.get_type(@client, type)
        unless interconnect_type
          list = OneviewSDK::Interconnect.get_types(@client).map { |t| t['name'] }
          raise OneviewSDK::NotFound, "Interconnect type #{type} not found! Supported types: #{list}"
        end
        type_port = interconnect_type['portInfos'].find { |p| port_formats.include? p['portName'] }
        raise OneviewSDK::NotFound, "Port #{port} not found!" unless type_port
        type_port['portNumber']
      end
    end
  end
end
