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

RSpec.shared_examples 'VolumeCreateExample' do |context_name|
  include_context context_name

  let(:storage_system_class) { resource_class_of('StorageSystem') }
  let(:storage_system) { storage_system_class.find_by(current_client, credentials: { ip_hostname: storage_system_ip }).first }
  let(:storage_pool) do
    data = { name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'] }
    resource_class_of('StoragePool').find_by(current_client, data).first
  end
  let(:vol_template) { resource_class_of('VolumeTemplate').find_by(current_client, name: VOL_TEMP_NAME).first }
  let(:options) do
    {
      description: 'Integration test volume',
      provisioningParameters: {
        provisionType: 'Full',
        requestedCapacity: 1024 * 1024 * 1024,
        shareable: true
      }
    }
  end

  describe '#create' do
    it 'create new volume' do
      item = described_class.new(current_client, options.merge(name: VOLUME_NAME))
      item.set_storage_system(storage_system)
      item.set_storage_pool(storage_pool)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME_NAME)
    end

    it 'create volume from a volume template' do
      options[:provisioningParameters] = { requestedCapacity: 1024 * 1024 * 1024 }

      item = described_class.new(current_client, options.merge(name: VOLUME2_NAME))
      item.set_storage_volume_template(vol_template)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME2_NAME)
    end

    it 'create volume with snapshot pool specified' do
      item = described_class.new(current_client, options.merge(name: VOLUME3_NAME))
      item.set_storage_system(storage_system)
      item.set_storage_pool(storage_pool)
      item.set_snapshot_pool(storage_pool)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME3_NAME)
    end

    it 'create volume from snapshot created only with name' do
      item = described_class.find_by(current_client, name: VOLUME2_NAME).first
      item.set_snapshot_pool(storage_pool)
      item.update
      item.retrieve!
      item.create_snapshot(VOL_SNAPSHOT_NAME)
      snap = item.get_snapshot(VOL_SNAPSHOT_NAME)

      item2 = described_class.new(current_client, options.merge(name: VOLUME4_NAME, snapshotUri: "#{item[:uri]}/snapshots/#{snap['uri']}"))
      item2.set_storage_system(storage_system)
      item2.set_storage_pool(storage_pool)
      item2.set_snapshot_pool(storage_pool)
      expect { item2.create }.to_not raise_error
      expect(item2.retrieve!).to eq(true)
      expect(item2['name']).to eq(VOLUME4_NAME)
    end

    it 'create volume from snapshot created from hash' do
      snapshot_data = {
        name: VOL_SNAPSHOT2_NAME,
        description: 'Snapshot created from hash',
        type: 'Snapshot'
      }
      item = described_class.find_by(current_client, name: VOLUME3_NAME).first
      item.create_snapshot(snapshot_data)
      snap = item.get_snapshot(VOL_SNAPSHOT2_NAME)

      item2 = described_class.new(current_client, options.merge(name: VOLUME5_NAME, snapshotUri: "#{item[:uri]}/snapshots/#{snap['uri']}"))
      item2.set_storage_system(storage_system)
      item2.set_storage_pool(storage_pool)
      expect { item2.create }.to_not raise_error
      expect(item2.retrieve!).to eq(true)
      expect(item2['name']).to eq(VOLUME5_NAME)
    end
  end

  describe '#set_storage_system' do
    before :each do
      @item = described_class.new(current_client, name: VOLUME_NAME)
    end

    it 'raises exception when storage system without uri' do
      storage_system = storage_system_class.new(current_client, name: STORAGE_SYSTEM_NAME)
      expect { @item.set_storage_system(storage_system) }.to raise_error(OneviewSDK::IncompleteResource, /#{STORAGE_SYSTEM_NAME} not found/)
    end

    it 'set_storage_system' do
      @item.set_storage_system(storage_system)
      expect(@item['storageSystemUri']).to eq(storage_system['uri'])
    end
  end

  describe '#set_storage_pool' do
    it 'set_storage_pool' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      item.set_storage_pool(storage_pool)
      expect(item['provisioningParameters']['storagePoolUri']).to eq(storage_pool['uri'])
    end
  end

  describe '#set_snapshot_pool' do
    it 'set_snapshot_pool' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      item.set_snapshot_pool(storage_pool)
      expect(item['snapshotPoolUri']).to eq(storage_pool['uri'])
    end
  end
end
