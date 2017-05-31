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

RSpec.shared_examples 'DatacenterUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'Changes name' do
      item = described_class.find_by(current_client, name: DATACENTER1_NAME).first
      item.update(name: DATACENTER1_NAME_UPDATED)
      expect(item[:name]).to eq(DATACENTER1_NAME_UPDATED)
      item.refresh
      item.update(name: DATACENTER1_NAME)
      expect(item[:name]).to eq(DATACENTER1_NAME)
    end
  end

  describe '#remove_rack' do
    it 'Removing a rack of the datacenter' do
      item = described_class.find_by(current_client, name: DATACENTER3_NAME).first
      rack = rack_class.find_by(current_client, name: RACK1_NAME).first
      item.remove_rack(rack)
      item.update
      item.retrieve!
      expect(item['contents']).to be_empty
    end
  end
end
