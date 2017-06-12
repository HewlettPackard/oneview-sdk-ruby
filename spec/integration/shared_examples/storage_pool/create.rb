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

RSpec.shared_examples 'StoragePoolCreateExample' do |context_name|
  include_context context_name

  let(:item_attributes) { { storageSystemUri: '/rest/storage-systems/TXQ1000307', poolName: 'CPG-SSD-AO' } }
  let(:storage_system_options) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip']
      }
    }
  end
  let(:storage_system_class) do
    namespace = described_class.to_s[0, described_class.to_s.rindex('::')]
    Object.const_get("#{namespace}::StorageSystem")
  end

  describe '#create' do
    it 'should throw unavailable exception' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#add' do
    it 'can add resources' do
      item = described_class.new(current_client, item_attributes)
      item.add
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
      expect(item['poolName']).to eq(STORAGE_POOL_NAME)
      expect(item['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      storage_system_ref = storage_system_class.new(current_client, storage_system_options)
      storage_system_ref.retrieve!
      item = described_class.new(current_client, name: STORAGE_POOL_NAME, storageSystemUri: storage_system_ref['uri'])
      item.retrieve!
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
      expect(item['name']).to eq(STORAGE_POOL_NAME)
      expect(item['uri']).to be
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = described_class.find_by(current_client, {}).map { |item| item['name'] }
      expect(names).to include(STORAGE_POOL_NAME)
    end

    it 'finds storage pools by multiple attributes' do
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      attrs = { name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'] }
      names = described_class.find_by(current_client, attrs).map { |item| item['name'] }
      expect(names).to include(STORAGE_POOL_NAME)
    end
  end

  describe '#set_storage_system' do
    it 'can set storage system before add storage pool' do
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      item = described_class.new(current_client)

      expect(item.set_storage_system(storage_system)).to eq(storage_system['uri'])
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
    end

    it 'should throw incomplete resource exception if storage system\'s uri is unknown' do
      storage_system = storage_system_class.new(current_client, storage_system_options)
      item = described_class.new(current_client)

      expect { item.set_storage_system(storage_system) }.to raise_error(OneviewSDK::IncompleteResource)
      expect { item.set_storage_system(storage_system) }.to raise_error(/Please set the storage system\'s uri attribute!/)
    end
  end

  describe '#exists?' do
    it 'returns true if storage pool exists' do
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      item = described_class.new(current_client, name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'])

      expect(item.exists?).to eq(true)
    end

    it 'returns false if storage pool not exists' do
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      item = described_class.new(current_client, name: 'some unknown nama', storageSystemUri: storage_system['uri'])

      expect(item.exists?).to eq(false)
    end

    it 'should throw incomplete resource exception if name and uri or storageSystemUri are unknown' do
      storage_system = storage_system_class.new(current_client, storage_system_options)
      storage_system.retrieve!
      item_without_name_and_uri = described_class.new(current_client, storageSystemUri: storage_system['uri'])
      item_without_storage_system_uri = described_class.new(current_client, name: 'some unknown nama')

      expect { item_without_name_and_uri.exists? }.to raise_error(OneviewSDK::IncompleteResource)
      expect { item_without_name_and_uri.exists? }.to raise_error(/Must set resource name or uri before trying to exists?/)

      expect { item_without_storage_system_uri.exists? }.to raise_error(OneviewSDK::IncompleteResource)
      expect { item_without_storage_system_uri.exists? }.to raise_error(/Must set resource storageSystemUri before trying to exists?/)
    end
  end
end
