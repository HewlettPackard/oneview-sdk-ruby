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

RSpec.shared_examples 'EnclosureUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.get_all(current_client).first }

  describe '#update' do
    it 'Changes name' do
      old_name = item['name']
      item.update(name: ENCL_NAME_UPDATED)
      expect(item[:name]).to eq(ENCL_NAME_UPDATED)
      item.update(name: old_name) # Put it back to normal
      expect(item[:name]).to eq(old_name)
    end

    it 'Changes rack name (it will fail due to a bug in the update)' do
      old_name = item['rackName']
      item.update(rackName: "#{old_name}_Updated")
      item.retrieve!
      expect(item[:rackName]).to eq("#{old_name}_Updated")
      item.update(rackName: old_name)
      item.retrieve!
      expect(item[:rackName]).to eq(old_name)
    end
  end

  describe '#configuration' do
    it 'Reapplies the appliances configuration on the enclosure (it will fail for monitored enclosure)' do
      expect { item.configuration }.not_to raise_error
    end
  end

  describe '#refreshState' do
    it 'returns all resources when the hash is empty' do
      expect { item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end

  describe '#patch' do
    it 'replaces the enclosure name and sets it back to the original' do
      old_name = item['name']
      expect { item.patch('replace', '/name', ENCL_NAME_UPDATED) }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(ENCL_NAME_UPDATED)
      expect { item.patch('replace', '/name', old_name) }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(old_name)
    end
  end
end
