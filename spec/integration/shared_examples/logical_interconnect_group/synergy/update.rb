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

RSpec.shared_examples 'LIGSynergyUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'adding and removing networks' do
      item = described_class.find_by(current_client, name: LOG_INT_GROUP2_NAME).first
      ethernet_network = ethernet_network_class.find_by(current_client, name: ETH_NET_NAME).first

      item['internalNetworkUris'] = []
      expect { item.update }.not_to raise_error

      item.retrieve!

      item.add_internal_network(ethernet_network)
      expect { item.update }.not_to raise_error

      expect(item['internalNetworkUris']).to eq([ethernet_network['uri']])
    end
  end
end
