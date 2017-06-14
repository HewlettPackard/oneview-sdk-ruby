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

RSpec.shared_examples 'VolumeTemplateCreateExample API500' do
  let(:item_attributes) do
    {
      name: VOL_TEMP_NAME,
      description: 'The volume template for test (with level user)'
    }
  end
  let(:storage_pool) { resource_class_of('StoragePool').get_all(current_client).find { |i| i['isManaged'] } }
  let(:root_template) { described_class.get_all(current_client).first }

  describe '#create' do
    it 'should create the resource' do
      item = described_class.new(current_client, item_attributes)
      item.set_root_template(root_template)
      item.set_default_value('storagePool', storage_pool)
      expect { item.create }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(item_attributes[:name])
      expect(item['description']).to eq(item_attributes[:description])
      expect(item.get_default_value('storagePool')).to eq(storage_pool['uri'])
      expect(item['storagePoolUri']).to eq(storage_pool['uri'])
      expect(item['rootTemplateUri']).to eq(root_template['uri'])
    end
  end

  describe '#get_compatible_systems' do
    it 'should create the resource' do
      item = described_class.find_by(current_client, name: item_attributes['name']).first
      storage_systems = nil
      expect { storage_systems = item.get_compatible_systems }.not_to raise_error
      expect(storage_systems).to be
      expect(storage_systems).not_to be_empty
    end
  end

  describe '::get_reachable_volume_templates' do
    it 'should create the resource' do
      templates = nil
      expect { templates = described_class.get_reachable_volume_templates(current_client) }.not_to raise_error
      expect(templates).to be
    end
  end
end
