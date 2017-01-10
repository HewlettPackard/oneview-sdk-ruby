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

require_relative '../../api200/logical_interconnect'

module OneviewSDK
  module API300
    module C7000
      # Logical interconnect resource implementation for API300 C7000
      class LogicalInterconnect < OneviewSDK::API200::LogicalInterconnect

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['type'] ||= 'logical-interconnectV300'
          super
        end

        # Lists internal networks on the logical interconnect
        # @return [OneviewSDK::Resource] List of networks
        def list_vlan_networks
          ensure_client && ensure_uri
          results = OneviewSDK::Resource.find_by(@client, {}, @data['uri'] + '/internalVlans')
          internal_networks = []
          results.each do |vlan|
            net = if vlan['generalNetworkUri'].include? 'ethernet-network'
                    OneviewSDK::API300::C7000::EthernetNetwork.new(@client, uri: vlan['generalNetworkUri'])
                  elsif vlan['generalNetworkUri'].include? 'fc-network'
                    OneviewSDK::API300::C7000::FCNetwork.new(@client, uri: vlan['generalNetworkUri'])
                  else
                    OneviewSDK::API300::C7000::FCoENetwork.new(@client, uri: vlan['generalNetworkUri'])
                  end
            net.retrieve!
            internal_networks.push(net)
          end
          internal_networks
        end

        # Updates settings of the logical interconnect
        # @param options Options to update the Logical Interconnect
        # @return Updated instance of the Logical Interconnect
        def update_settings(options = {})
          options['type'] ||= 'InterconnectSettingsV201'
          options['ethernetSettings'] ||= {}
          options['ethernetSettings']['type'] ||= 'EthernetInterconnectSettingsV201'
          super(options)
        end
      end
    end
  end
end
