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

RSpec.shared_examples 'NetworkSetCreateExample' do |context_name|
  include_context context_name

  describe '#create' do
    it 'network set withoutEthernet' do
      item = described_class.new(current_client)
      item['name'] = NETWORK_SET1_NAME
      item.create
      expect(item['uri']).to_not eq(nil)
    end

    it 'network set with ethernet network' do
      eth1 = ethernet_class.find_by(current_client, {}).first
      item = described_class.new(current_client)
      item['name'] = NETWORK_SET2_NAME
      item.add_ethernet_network(eth1)
      item.create
      expect(item['uri']).to_not eq(nil)
      expect(item['networkUris']).to include(eth1['uri'])
    end

    it 'network set with multiple ethernet networks' do
      eth1 = ethernet_class.find_by(current_client, {}).first
      eth2 = ethernet_class.find_by(current_client, {}).last
      item = described_class.new(current_client)
      item['name'] = NETWORK_SET3_NAME
      item.add_ethernet_network(eth1)
      item.add_ethernet_network(eth2)
      item.create
      expect(item['uri']).to_not eq(nil)
      expect(item['networkUris']).to include(eth1['uri'])
      expect(item['networkUris']).to include(eth2['uri'])
    end

    it 'network set with native network' do
      eth1 = ethernet_class.find_by(current_client, {}).first
      item = described_class.new(current_client)
      item['name'] = NETWORK_SET4_NAME
      item.set_native_network(eth1)
      item.create
      expect(item['uri']).to_not eq(nil)
      expect(item['nativeNetworkUri']).to include(eth1['uri'])
    end
  end
end
