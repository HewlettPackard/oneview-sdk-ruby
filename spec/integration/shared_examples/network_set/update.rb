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

RSpec.shared_examples 'NetworkSetUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'updating the name' do
      item = described_class.find_by(current_client, name: NETWORK_SET3_NAME).first
      item['name'] = "#{NETWORK_SET3_NAME}_Updated"
      item.update
      item.retrieve!
      expect(item['name']).to eq("#{NETWORK_SET3_NAME}_Updated")

      item['name'] = NETWORK_SET3_NAME
      item.update
      item.retrieve!
      expect(item['name']).to eq(NETWORK_SET3_NAME)
    end
  end

  describe '#remove_ethernet_network' do
    it 'removing an ethernet network' do
      item = described_class.find_by(current_client, name: NETWORK_SET2_NAME).first
      eth1 = ethernet_class.new(current_client, uri: item['networkUris'].first)
      item.remove_ethernet_network(eth1)
      item.update
      item.retrieve!
      expect(item['networkUris']).to be_empty
      item.add_ethernet_network(eth1)
      item.update
      item.retrieve!
      expect(item['networkUris']).to include(eth1['uri'])
    end
  end

  describe '#get_without_ethernet' do
    it 'instance' do
      item = described_class.new(current_client, name: NETWORK_SET3_NAME)
      item.retrieve!
      item_without_networks = item.get_without_ethernet
      expect(item_without_networks['networkUris']).to eq([])
    end

    it 'class' do
      described_class.get_without_ethernet(current_client)['members'].each do |network_set|
        expect(network_set['networkUris']).to eq([])
      end
    end
  end
end
