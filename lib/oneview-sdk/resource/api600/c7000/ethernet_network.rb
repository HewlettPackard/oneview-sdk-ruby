# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../api500/c7000/ethernet_network'

module OneviewSDK
  module API600
    module C7000
      # Ethernet network resource implementation for API600 C7000
      class EthernetNetwork < OneviewSDK::API500::C7000::EthernetNetwork
        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          @data ||= {}
          # Default values:
          @data['ethernetNetworkType'] ||= 'Tagged'
          @data['type'] ||= 'ethernet-networkV4'
          super
        end

        # Bulk create the ethernet networks
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] options information necessary to create networks
        # @return [Array] list of ethernet networks created
        def self.bulk_create(client, options)
          range = options[:vlanIdRange].split('-').map(&:to_i)
          options[:type] = 'bulk-ethernet-networkV1'
          response = client.rest_post(BASE_URI + '/bulk', { 'body' => options }, client.api_version)
          client.response_handler(response)
          network_names = []
          range[0].upto(range[1]) { |i| network_names << "#{options[:namePrefix]}_#{i}" }
          OneviewSDK::EthernetNetwork.get_all(client).select { |network| network_names.include?(network['name']) }
        end
      end
    end
  end
end
