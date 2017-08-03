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

RSpec.shared_examples 'EthernetNetworkUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'update name' do
      item = described_class.new(current_client, name: ETH_NET_NAME)
      item.retrieve!
      item.update(name: ETH_NET_NAME_UPDATED)
      item.refresh
      expect(item[:name]).to eq(ETH_NET_NAME_UPDATED)
      item.update(name: ETH_NET_NAME)
      item.refresh
      expect(item[:name]).to eq(ETH_NET_NAME)
    end
  end
end
