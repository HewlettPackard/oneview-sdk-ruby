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

RSpec.shared_examples 'StoragePoolCreateExample API500' do
  include_context 'integration api500 context'

  describe '#create' do
    it 'should throw unavailable exception' do
      item = described_class.new($client_500)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#create!' do
    it 'should throw unavailable exception' do
      item = described_class.new(current_client)
      expect { item.create! }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  # setting a storage pool as managed because it will be used by other resource tests
  describe 'setting a storage pool as managed' do
    it 'should set to managed' do
      item = described_class.find_by($client_500, name: STORAGE_POOL_NAME).first
      expect(item).to be
      expect { item.manage(true) }.not_to raise_error
    end
  end

  describe '::reachable' do
    it 'should get the storage pools' do
      expect(described_class.reachable($client_500)).not_to be_empty
    end

    it 'should get the storage pools that are connected on the specified networks' do
      storage_pool = described_class.reachable($client_500).first
      network_uri = storage_pool['reachableNetworks'].first
      fc_network = resource_class_of('FCNetwork').new($client_500, uri: network_uri)
      expect(described_class.reachable($client_500, [fc_network])).not_to be_empty
    end

    it 'should get the empty list when not connected on the specified networks' do
      fc_network = resource_class_of('FCNetwork').new($client_500, uri: '/rest/fc-networks/fake-UUID')
      expect(described_class.reachable($client_500, [fc_network])).to be_empty
    end
  end

  describe '#retrieve!' do
    it 'should retrieve the storage_pool created by name and storageSystemUri' do
      item_created = described_class.find_by($client_500, name: STORAGE_POOL_NAME).first
      item_found = described_class.new($client_500, name: item_created['name'], storageSystemUri: item_created['storageSystemUri'])
      expect(item_found.retrieve!).to eq(true)
      expect(item_found['uri']).to eq(item_created['uri'])

      item_found = described_class.new($client_500, name: 'Some wrong name', storageSystemUri: item_created['storageSystemUri'])
      expect(item_found.retrieve!).to eq(false)
      expect(item_found['uri']).not_to be

      item_found = described_class.new($client_500, name: item_created['name'], storageSystemUri: '/other-uri/1')
      expect(item_found.retrieve!).to eq(false)
      expect(item_found['uri']).not_to be
    end
  end

  describe '#exists?' do
    it 'should verify if exists the storage_pool created by name and storageSystemUri' do
      item_created = described_class.find_by($client_500, name: STORAGE_POOL_NAME).first
      item_found = described_class.new($client_500, name: item_created['name'], storageSystemUri: item_created['storageSystemUri'])
      expect(item_found.exists?).to eq(true)

      item_found = described_class.new($client_500, name: 'Some wrong name', storageSystemUri: item_created['storageSystemUri'])
      expect(item_found.exists?).to eq(false)

      item_found = described_class.new($client_500, name: item_created['name'], storageSystemUri: '/other-uri/1')
      expect(item_found.exists?).to eq(false)
    end
  end
end
