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

  let(:item2_attributes) do
    {
      name: VOL_TEMP_VIRTUAL_NAME,
      description: 'The volume template for test (with level user)'
    }
  end
  let(:storage_pool) do
    storage_system = resource_class_of('StorageSystem').find_by(current_client, hostname: storage_system_ip).first
    resource_class_of('StoragePool').find_by(current_client, storageSystemUri: storage_system['uri'], isManaged: true).first
  end
  let(:storage_virtual_pool) do
    storage_virtual = resource_class_of('StorageSystem').find_by(current_client, hostname: storage_virtual_ip).first
    resource_class_of('StoragePool').find_by(current_client, storageSystemUri: storage_virtual['uri'], isManaged: true).first
  end
  let(:root_template) { described_class.find_by(current_client, isRoot: true, family: 'StoreServ').first }
  let(:root_virtual_template) { described_class.find_by(current_client, isRoot: true, family: 'StoreVirtual').first }

  describe '#create' do
    it 'should create the resource - Store Serv' do
      item = described_class.new(current_client, item_attributes)
      item.set_root_template(root_template)
      item.set_default_value('storagePool', storage_pool)
      item.set_default_value('snapshotPool', storage_pool)
      expect { item.create }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(item_attributes[:name])
      expect(item['description']).to eq(item_attributes[:description])
      expect(item.get_default_value('storagePool')).to eq(storage_pool['uri'])
      expect(item['storagePoolUri']).to eq(storage_pool['uri'])
      expect(item['rootTemplateUri']).to eq(root_template['uri'])
    end

    it 'should create the resource - Store Virtual' do
      item = described_class.new(current_client, item2_attributes)
      item.set_root_template(root_virtual_template)
      item.set_default_value('storagePool', storage_virtual_pool)
      expect { item.create }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(item2_attributes[:name])
      expect(item['description']).to eq(item2_attributes[:description])
      expect(item.get_default_value('storagePool')).to eq(storage_virtual_pool['uri'])
      expect(item['storagePoolUri']).to eq(storage_virtual_pool['uri'])
      expect(item['rootTemplateUri']).to eq(root_virtual_template['uri'])
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
