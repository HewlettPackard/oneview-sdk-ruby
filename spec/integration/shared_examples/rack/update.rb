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

RSpec.shared_examples 'RackUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, {}).find { |item| !item['rackMounts'].empty? } }
  let(:enclosure) { resource_class_of('Enclosure').get_all(current_client).first }

  describe '#update' do
    it 'updates depth' do
      current_name = item['name']
      item.update(name: "#{current_name}_Updated")
      sleep(5)
      item.refresh
      expect(item['name']).to eq("#{current_name}_Updated")
      # returning to original name
      item.update(name: current_name)
      sleep(5)
      item.refresh
      expect(item['name']).to eq(current_name)
    end

    it 'removing an enclosure of the rack' do
      item.remove_rack_resource(enclosure)
      item.update
      item.refresh
      enclosure_mount = item['rackMounts'].find { |resource_from_rack| resource_from_rack['mountUri'] == enclosure['uri'] }
      expect(enclosure_mount).to be_nil
    end

    it 'adding an enclosure on the rack' do
      item.add_rack_resource(enclosure, topUSlot: 20, uHeight: 10)
      item.update
      item.refresh
      enclosure_mount = item['rackMounts'].find { |resource_from_rack| resource_from_rack['mountUri'] == enclosure['uri'] }
      expect(enclosure_mount['mountUri']).to eq(enclosure['uri'])
      expect(enclosure_mount['topUSlot']).to eq(20)
      expect(enclosure_mount['uHeight']).to eq(10)
    end
  end
end
