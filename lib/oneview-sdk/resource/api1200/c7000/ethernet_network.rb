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

require_relative '../../api1000/c7000/ethernet_network'

module OneviewSDK
  module API1200
    module C7000
      # Ethernet network resource implementation for API1200 C7000
      class EthernetNetwork < OneviewSDK::API1000::C7000::EthernetNetwork
        # Bulk create the ethernet networks
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Hash] options information necessary to create networks
        # @return [Array] list of ethernet networks created
        def self.bulk_create(client, options)
          range = options[:vlanIdRange].split('-').map(&:to_i)
          options[:type] = 'bulk-ethernet-networkV2'
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
