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

RSpec.shared_examples 'VolumeCreateExample API500' do |context_name|
  include_context context_name

  let(:namespace) { described_class.to_s[0, described_class.to_s.rindex('::')] }
  let(:storage_system_class) { resource_class_of('StorageSystem') }
  let(:storage_system) { storage_system_class.find_by(current_client, hostname: storage_system_ip).first }
  let(:storage_pool) do
    data = { name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'] }
    resource_class_of('StoragePool').find_by(current_client, data).first
  end
  let(:storage_virtual) { storage_system_class.find_by(current_client, hostname: storage_virtual_ip).first }
  let(:storage_virtual_pool) do
    data = { storageSystemUri: storage_virtual['uri'] }
    resource_class_of('StoragePool').find_by(current_client, data).first
  end
  let(:volume_template_class) { resource_class_of('VolumeTemplate') }
  let(:vol_template) { volume_template_class.new(current_client, name: VOL_TEMP_NAME) }
  let(:vol_template_virtual) { volume_template_class.new(current_client, name: VOL_TEMP_VIRTUAL_NAME) }

  let(:options_store_serv) do
    {
      description: 'Volume store serv',
      size: 1024 * 1024 * 1024,
      provisioningType: 'Thin',
      isShareable: true
    }
  end

  let(:options_store_virtual) do
    {
      name: VOLUME_VIRTUAL_NAME,
      description: 'Volume store virtual',
      size: 1024 * 1024 * 1024,
      provisioningType: 'Thin',
      dataProtectionLevel: 'NetworkRaid10Mirror2Way'
    }
  end

  describe '#create' do
    it 'create new volume' do
      item = described_class.new(current_client, properties: options_store_serv.merge(name: VOLUME_NAME))
      item.set_storage_pool(storage_pool)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME_NAME)
    end

    it 'create volume from a volume template' do
      item = described_class.new(current_client, properties: options_store_serv.merge(name: VOLUME2_NAME))
      item.set_storage_pool(storage_pool)
      item.set_storage_volume_template(vol_template)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME2_NAME)
    end

    it 'create volume with snapshot pool specified' do
      item = described_class.new(current_client, properties: options_store_serv.merge(name: VOLUME3_NAME))
      item.set_storage_pool(storage_pool)
      item.set_snapshot_pool(storage_pool)
      item.set_storage_volume_template(vol_template)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME3_NAME)
    end

    it 'create volume from store virtual without a volume template' do
      item = described_class.new(current_client, properties: options_store_virtual.merge(name: VOLUME_VIRTUAL_NAME))
      item.set_storage_pool(storage_virtual_pool)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME_VIRTUAL_NAME)
    end

    it 'create volume from store virtual with a volume template' do
      item = described_class.new(current_client, properties: options_store_virtual.merge(name: VOLUME_VIRTUAL2_NAME))
      item.set_storage_pool(storage_virtual_pool)
      item.set_storage_volume_template(vol_template_virtual)
      expect { item.create }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(VOLUME_VIRTUAL2_NAME)
    end
  end

  describe '#create_snapshot' do
    it 'creating a snapshot only with name' do
      item = described_class.find_by(current_client, name: VOLUME2_NAME).first
      expect { item.create_snapshot(VOL_SNAPSHOT_NAME) }.to_not raise_error
      snap = item.get_snapshot(VOL_SNAPSHOT_NAME)
      expect(snap['name']).to eq(VOL_SNAPSHOT_NAME)
    end

    it 'creating a snapshot from a hash' do
      snapshot_data = {
        name: VOL_SNAPSHOT2_NAME,
        description: 'Snapshot created from hash',
        type: 'Snapshot'
      }
      item = described_class.find_by(current_client, name: VOLUME3_NAME).first
      expect { item.create_snapshot(snapshot_data) }.to_not raise_error
      snap = item.get_snapshot(VOL_SNAPSHOT2_NAME)
      expect(snap['name']).to eq(VOL_SNAPSHOT2_NAME)
    end
  end

  describe '#create_from_snapshot' do
    before :all do
      @properties = {
        'provisioningType' => 'Thin',
        'name' => VOLUME4_NAME,
        'isShareable' => false
      }
    end
    it 'raises an exception when snapshot not found' do
      item = described_class.find_by(current_client, name: VOLUME3_NAME).first
      expect { item.create_from_snapshot('Any', {}) }.to raise_error(/Snapshot not found/)
    end

    it 'raises an exception when volume template not found' do
      item = described_class.find_by(current_client, name: VOLUME3_NAME).first
      template = volume_template_class.new(current_client, name: 'Any')
      expect { item.create_from_snapshot(VOL_SNAPSHOT2_NAME, {}, template) }.to raise_error(/Volume Template not found/)
    end

    it 'creating a volume from snapshot without a specific template' do
      item = described_class.find_by(current_client, name: VOLUME3_NAME).first
      volume = nil
      expect { volume = item.create_from_snapshot(VOL_SNAPSHOT2_NAME, @properties) }.to_not raise_error
      expect(volume.retrieve!).to eq(true)
      expect(volume['name']).to eq(VOLUME4_NAME)
      expect(volume['provisioningType']).to eq('Thin')
      expect(volume['isShareable']).to eq(false)
    end

    it 'creating a volume from snapshot with a specific template' do
      item = described_class.new(current_client, name: VOLUME4_NAME)
      item.delete if item.retrieve!

      item2 = described_class.find_by(current_client, name: VOLUME3_NAME).first
      volume = nil
      expect { volume = item2.create_from_snapshot(VOL_SNAPSHOT2_NAME, @properties, vol_template) }.to_not raise_error
      expect(volume.retrieve!).to eq(true)
      expect(volume['name']).to eq(VOLUME4_NAME)
      expect(volume['provisioningType']).to eq('Thin')
      expect(volume['isShareable']).to eq(false)
    end
  end

  describe '#add' do
    it 'raises an exception when storage system not found' do
      storage = storage_system_class.new(current_client, name: 'Any')
      expect { described_class.add(current_client, storage, 'any') }.to raise_error(/Storage system not found/)
    end

    it 'adding a volume' do
      item = described_class.new(current_client, properties: options_store_serv.merge(name: VOLUME5_NAME))
      item.set_storage_pool(storage_pool)
      item.set_snapshot_pool(storage_pool)
      item.create
      device_volume = item['deviceVolumeName']
      expect { item.delete(:oneview) }.to_not raise_error

      volume = nil
      options = {
        'name' => VOLUME5_NAME,
        'description' => 'adding a volume'
      }
      expect { volume = described_class.add(current_client, storage_system, device_volume, false, options) }.to_not raise_error
      expect(volume.retrieve!).to eq(true)
      expect(volume['name']).to eq(VOLUME5_NAME)
      expect(volume['isShareable']).to eq(false)
      expect(volume['deviceVolumeName']).to eq(device_volume)
    end
  end

  describe '#set_storage_system' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.set_storage_system(storage_system) }.to raise_error(/The method #set_storage_system is unavailable for this resource/)
    end
  end

  describe '#set_storage_pool' do
    it 'set_storage_pool' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      item.set_storage_pool(storage_pool)
      expect(item['properties']['storagePool']).to eq(storage_pool['uri'])
    end
  end

  describe '#set_snapshot_pool' do
    it 'set_snapshot_pool' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      item.set_snapshot_pool(storage_pool)
      expect(item['properties']['snapshotPool']).to eq(storage_pool['uri'])
    end
  end

  describe '#retrieve!' do
    it 'should call super method when properties is not set' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      expect(item.retrieve!).to eq(true)
    end

    it 'should find by name when properties is set' do
      item = described_class.new(current_client, properties: { name: 'volume 1' })
      expect(item.retrieve!).to eq(false)
      item = described_class.new(current_client, properties: { name: VOLUME_NAME })
      expect(item.retrieve!).to eq(true)
    end

    it 'raises an exception when uri or name and property is not set' do
      item = described_class.new(current_client, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name or uri before/)
    end

    it 'raises an exception name is not set and property is set' do
      item = described_class.new(current_client, properties: {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name within the properties before/)
    end
  end

  describe '#exists?' do
    it 'should call super method when properties is not set' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      expect(item.exists?).to eq(true)
    end

    it 'should find by name when properties is set' do
      item = described_class.new(current_client, properties: { name: 'volume 1' })
      expect(item.exists?).to eq(false)
      item = described_class.new(current_client, properties: { name: VOLUME_NAME })
      expect(item.exists?).to eq(true)
    end

    it 'raises an exception when uri or name and property is not set' do
      item = described_class.new(current_client, {})
      expect { item.exists? } .to raise_error(OneviewSDK::IncompleteResource, /Must set resource name or uri before/)
    end

    it 'raises an exception name is not set and property is set' do
      item = described_class.new(current_client, properties: {})
      expect { item.exists? } .to raise_error(OneviewSDK::IncompleteResource, /Must set resource name within the properties before/)
    end
  end
end
