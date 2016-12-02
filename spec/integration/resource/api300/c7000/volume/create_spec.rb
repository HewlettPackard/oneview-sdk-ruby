require 'spec_helper'

klass = OneviewSDK::API300::C7000::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    storage_system_data = { credentials: { ip_hostname: $secrets['storage_system1_ip'] } }
    @storage_system = OneviewSDK::API300::C7000::StorageSystem.new($client_300, storage_system_data)
    @storage_system.retrieve!
    storage_pool_data = { name: STORAGE_POOL_NAME, storageSystemUri: @storage_system['uri'] }
    @storage_pool = OneviewSDK::API300::C7000::StoragePool.new($client_300, storage_pool_data)
    @storage_pool.retrieve!
    @vol_template = OneviewSDK::API300::C7000::VolumeTemplate.new($client_300, name: VOL_TEMP_NAME)
  end

  describe '#create' do
    before :each do
      volume = klass.new($client_300, name: VOLUME_NAME)
      volume.delete if volume.retrieve!
    end

    it 'create new volume' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        provisioningParameters: {
          provisionType: 'Full',
          storagePoolUri: @storage_pool[:uri],
          requestedCapacity: 1024 * 1024 * 1024
        }
      }
      volume = klass.new($client_300, options)
      volume.create
    end

    it 'create volume from a volume template' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        templateUri: @vol_template[:uri],
        provisioningParameters: {
          provisionType: 'Thin',
          storagePoolUri: @storage_pool[:uri],
          requestedCapacity: 1024 * 1024 * 1024
        }
      }
      volume = klass.new($client_300, options)
      volume.create
    end

    it 'create volume with snapshot pool specified' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        snapshotPoolUri: @storage_pool[:uri],
        provisioningParameters: {
          provisionType: 'Full',
          storagePoolUri: @storage_pool[:uri],
          requestedCapacity: 1024 * 1024 * 1024
        }
      }
      volume = klass.new($client_300, options)
      volume.create
    end

    # REAL HARDWARE ONLY
    # it 'add volume for management' do
    #   options = {
    #     name: VOLUME_NAME,
    #     description: 'Integration test volume',
    #     storageSystemUri: @storage_system[:uri],
    #     provisioningParameters: {
    #       provisionType: 'Full',
    #       storagePoolUri: @storage_pool[:uri],
    #       requestedCapacity: 1024 * 1024 * 1024
    #     }
    #   }
    #   volume = klass.new($client_300, options)
    #   volume.create
    #   wwn = volume[:wwn]
    #
    #   # Delete only from oneview
    #   volume.delete(:oneview)
    #
    #   options = {
    #     name: VOLUME_NAME,
    #     description: 'Integration test volume',
    #     storageSystemUri: @storage_system[:uri],
    #     type: 'AddStorageVolumeV2',
    #     wwn: wwn
    #   }
    #   volume = klass.new($client_300, options)
    #   volume.create
    # end
    #
    # it 'add volume for management using volume name in storage system' do
    #   options = {
    #     name: VOLUME_NAME,
    #     description: 'Integration test volume',
    #     storageSystemUri: @storage_system[:uri],
    #     snapshotPoolUri: @storage_pool[:uri],
    #     provisioningParameters: {
    #       provisionType: 'Full',
    #       storagePoolUri: @storage_pool[:uri],
    #       requestedCapacity: 1024 * 1024 * 1024
    #     }
    #   }
    #   volume = klass.new($client_300, options)
    #   volume.create(
    #   )
    #
    #   storage_system_volume_name = volume[:deviceVolumeName]
    #
    #   # Delete only from oneview
    #   volume.delete(:oneview)
    #
    #   options = {
    #     name: VOLUME_NAME,
    #     description: 'Integration test volume',
    #     storageSystemUri: @storage_system[:uri],
    #     storageSystemVolumeName: storage_system_volume_name,
    #     type: 'AddStorageVolumeV3'
    #   }
    #   volume = klass.new($client_300, options)
    #   volume.create
    # end

    it 'create volume from snapshot created only with name' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        snapshotPoolUri: @storage_pool[:uri],
        provisioningParameters: {
          provisionType: 'Full',
          storagePoolUri: @storage_pool[:uri],
          requestedCapacity: 1024 * 1024 * 1024
        }
      }
      volume = klass.new($client_300, options)
      volume.create

      volume.create_snapshot(VOL_SNAPSHOT_NAME)
      snap = volume.get_snapshot(VOL_SNAPSHOT_NAME)

      options = {
        type: 'AddStorageVolumeV3',
        name: VOLUME2_NAME,
        description: 'Integration test volume 2',
        snapshotPoolUri: @storage_pool[:uri],
        storageSystemUri: @storage_system[:uri],
        snapshotUri: "#{volume[:uri]}/snapshots/#{snap['uri']}",
        provisioningParameters: {
          storagePoolUri: @storage_pool[:uri]
        }
      }
      volume_2 = klass.new($client_300, options)
      expect { volume_2.create }.to_not raise_error
    end

    it 'create volume from snapshot created from hash' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        snapshotPoolUri: @storage_pool[:uri],
        provisioningParameters: {
          provisionType: 'Full',
          storagePoolUri: @storage_pool[:uri],
          requestedCapacity: 1024 * 1024 * 1024
        }
      }
      volume = klass.new($client_300, options)
      volume.create

      snapshot_data = {
        name: VOL_SNAPSHOT2_NAME,
        description: 'Snapshot created from hash',
        type: 'Snapshot'
      }

      volume.create_snapshot(snapshot_data)
      snap = volume.get_snapshot(VOL_SNAPSHOT2_NAME)

      options = {
        type: 'AddStorageVolumeV3',
        name: VOLUME3_NAME,
        description: 'Integration test volume 2',
        snapshotPoolUri: @storage_pool[:uri],
        storageSystemUri: @storage_system[:uri],
        snapshotUri: "#{volume[:uri]}/snapshots/#{snap['uri']}",
        provisioningParameters: {
          storagePoolUri: @storage_pool[:uri]
        }
      }
      volume_3 = klass.new($client_300, options)
      expect { volume_3.create }.to_not raise_error
    end
  end

  describe '#set_storage_system' do
    before :each do
      @volume = klass.new($client_300, name: VOLUME_NAME)
    end

    it 'raises exception when storage system without uri' do
      storage_system = OneviewSDK::API300::C7000::StorageSystem.new($client_300, name: STORAGE_SYSTEM_NAME)
      expect { @volume.set_storage_system(storage_system) }.to raise_error(OneviewSDK::IncompleteResource, /#{STORAGE_SYSTEM_NAME} not found/)
    end

    it 'set_storage_system' do
      @volume.set_storage_system(@storage_system)
      expect(@volume['storageSystemUri']).to eq(@storage_system['uri'])
    end
  end

  describe '#set_storage_pool' do
    it 'set_storage_pool' do
      volume = klass.new($client_300, name: VOLUME_NAME)
      volume.set_storage_pool(@storage_pool)
      expect(volume['provisioningParameters']['storagePoolUri']).to eq(@storage_pool['uri'])
    end
  end

  describe '#set_snapshot_pool' do
    it 'set_snapshot_pool' do
      volume = klass.new($client_300, name: VOLUME_NAME)
      volume.set_snapshot_pool(@storage_pool)
      expect(volume['snapshotPoolUri']).to eq(@storage_pool['uri'])
    end
  end

  describe '#set_storage_volume_template' do
    it 'set_storage_volume_template' do
      volume = klass.new($client_300, name: VOLUME_NAME)
      @vol_template.retrieve!
      volume.set_storage_volume_template(@vol_template)
      expect(volume['templateUri']).to eq(@vol_template['uri'])
    end
  end

  describe '#get_attachable_volumes' do
    it 'gets all the attachable volumes managed by the appliance' do
      expect { klass.get_attachable_volumes($client_300) }.to_not raise_error
    end
  end

  describe '#get_extra_managed_volume_paths' do
    it 'gets the list of extra managed storage volume paths' do
      expect { klass.get_extra_managed_volume_paths($client_300) }.to_not raise_error
    end
  end
end
