# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'LIGC7000UpdateExample' do |context_name|
  include_context context_name

  let(:eth) { ethernet_network_class.find_by(current_client, name: ETH_NET_NAME).first }
  let(:uplink_options) do
    {
      name: LIG_UPLINK_SET4_NAME,
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
  end
  let(:uplink) { lig_uplink_set_class.new(current_client, uplink_options) }

  describe '#update' do
    it 'adding and removing uplink set' do
      uplink.add_network(eth)
      uplink.add_uplink(1, 'X1')

      item.add_uplink_set(uplink)

      expect { item.update }.not_to raise_error

      expect(item['uri']).to be
      expect(item['uplinkSets']).to_not be_empty

      item['uplinkSets'].clear
      expect { item.update }.to_not raise_error
      expect(item['uri']).to be
      expect(item['uplinkSets']).to be_empty
    end
  end
end
