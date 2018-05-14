# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api500/c7000/server_profile'

module OneviewSDK
  module API600
    module C7000
      # Server Profile resource implementation on API600 C7000
      class ServerProfile < OneviewSDK::API500::C7000::ServerProfile
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interacting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values
          @data['type'] ||= 'ServerProfileV8'
          super
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def self.get_available_storage_system(*)
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def self.get_available_storage_systems(*)
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def get_messages(*)
          unavailable_method
        end

        # Adds a connection entry to server profile template
        # @param [OneviewSDK::EthernetNetwork, OneviewSDK::FCNetwork] network Network associated with the connection
        # @param [Hash<String,String>] connection_options Hash containing the configuration of the connection
        # @option connection_options [Boolean] 'boot' Indicates that the server will attempt to boot from this connection.
        # @option connection_options [String] 'functionType' Type of function required for the connection. Values: Ethernet, FibreChannel, iSCSI.
        # @option connection_options [Integer] 'id' A unique identifier for this connection. If 0, id is automatically assigned.
        # @option connection_options [String] 'ipv4' The IP information for a connection. This is only used for iSCSI connections.
        # @option connection_options [String] 'name' Name of the connection.
        # @option connection_options [String] 'portId' Identifies the port (FlexNIC) used for this connection.
        # @option connection_options [String] 'requestedMbps' The transmit throughput (mbps) that should be allocated to this connection.
        # @option connection_options [String] 'requestedVFs' This value can be "Auto" or 0.
        def add_connection(network, connection_options = {})
          connection_options = Hash[connection_options.map { |k, v| [k.to_s, v] }]
          self['connectionSettings'] = {} unless self['connectionSettings']
          self['connectionSettings']['connections'] = [] unless self['connectionSettings']['connections']
          connection_options['id'] ||= 0
          connection_options['networkUri'] = network['uri'] if network['uri'] || network.retrieve!
          self['connectionSettings']['connections'] << connection_options
        end

        # Removes a connection entry in server profile template
        # @param [String] connection_name Name of the connection
        # @return Returns the connection hash if found, otherwise returns nil
        def remove_connection(connection_name)
          desired_connection = nil
          return desired_connection unless self['connectionSettings']['connections']
          self['connectionSettings']['connections'].each do |con|
            desired_connection = self['connectionSettings']['connections'].delete(con) if con['name'] == connection_name
          end
          desired_connection
        end
      end
    end
  end
end
