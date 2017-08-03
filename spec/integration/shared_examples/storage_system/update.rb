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

RSpec.shared_examples 'StorageSystemUpdateExample' do |context_name, api_version|
  include_context context_name

  let(:item_attributes_2) { JSON.load(item_attributes.to_json) }

  describe '#update', if: api_version <= 300 do
    it '#updating fc_network unmanaged ports' do
      storage_system = described_class.new(current_client, item_attributes)
      storage_system.retrieve!

      fc_network = OneviewSDK::FCNetwork.find_by(current_client, name: FC_NET_NAME).first

      storage_system.data['unmanagedPorts'].first['expectedNetworkUri'] = fc_network.data['uri']
      storage_system.update
      new_item = described_class.new(current_client, item_attributes)
      new_item.retrieve!

      ports = new_item.get_managed_ports
      expect(ports).not_to be_empty
      expect(ports.size).to eq(1)
      expect(ports.first['expectedNetworkUri']).to eq(fc_network.data['uri'])
    end
  end

  describe '#set_refresh_state', if: api_version <= 300 do
    it 'Refreshing a storage system' do
      storage_system = described_class.find_by(current_client, item_attributes).first
      expect { storage_system.set_refresh_state('RefreshPending') }.not_to raise_error
      expect(storage_system['refreshState']).to eq('RefreshPending')
    end
  end

  describe '#like?' do
    it 'must not compare storage system credentials with password and hash String' do
      storage_system = described_class.new(current_client, item_attributes)
      storage_system.retrieve!
      expect(storage_system.like?(item_attributes)).to eq(true)
    end

    it 'must not compare storage system credentials with password and key Symbol' do
      storage_system = described_class.new(current_client, item_attributes)
      storage_system.retrieve!
      expect(storage_system.like?(item_attributes_2)).to eq(true)
    end

    it 'must not compare storage system credentials with password when compares resources' do
      storage_system = described_class.new(current_client, item_attributes)
      storage_system.retrieve!
      item2 = described_class.new(current_client, item_attributes)
      expect(storage_system.like?(item2)).to eq(true)
    end

    it 'must not compare storage system with invalid data types' do
      storage_system = described_class.new(current_client, item_attributes)
      storage_system.retrieve!
      expect(storage_system.like?(credentials: true)).to eq(false)
    end
  end

  describe '#exists?' do
    it 'finds it by managedDomain', if: api_version <= 300 do
      expect(described_class.new(current_client, item_attributes_2).exists?).to be true
      expect(described_class.new(current_client, managedDomain: 'fake', credentials: { ip_hostname: 'fake' }).exists?).to be false
    end

    it 'finds it by credentials', if: api_version <= 300 do
      expect(described_class.new(current_client, item_attributes).exists?).to be true
      expect(described_class.new(current_client, credentials: { ip_hostname: 'fake' }).exists?).to be false
    end

    it 'raises an exception if no identifiers are given' do
      item = described_class.new(current_client, {})
      expect { item.exists? }.to raise_error(OneviewSDK::IncompleteResource)
    end
    it 'raises an exception when ip_hostname is not passed' do
      item = described_class.new(current_client, credentials: {})
      expect { item.exists? }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end
end
