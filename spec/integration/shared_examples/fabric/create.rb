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

RSpec.shared_examples 'FabricCreateExample' do |context_name, only_synergy|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, name: DEFAULT_FABRIC_NAME).first }

  describe '#create' do
    it 'raises MethodUnavailable' do
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end

  describe '#find_by' do
    it 'find by default name' do
      fabric = described_class.find_by(current_client, name: DEFAULT_FABRIC_NAME).first
      expect(fabric['name']).to eq(DEFAULT_FABRIC_NAME)
    end
  end

  describe '#get_reserved_vlan_range', if: only_synergy do
    it 'gets the reserved vlan range attributes successfully' do
      expect { item.get_reserved_vlan_range }.not_to raise_error
    end
  end

  describe '#set_reserved_vlan_range', if: only_synergy do
    it 'sets new reserved vlan range attributes successfully' do
      expect { item.set_reserved_vlan_range(start: 105, length: 105, type: 'vlan-pool') }.not_to raise_error
      expect(item.get_reserved_vlan_range['start']).to eq(105)
      expect { item.set_reserved_vlan_range(start: 100, length: 100, type: 'vlan-pool') }.not_to raise_error
      expect(item.get_reserved_vlan_range['start']).to eq(100)
    end
  end
end
