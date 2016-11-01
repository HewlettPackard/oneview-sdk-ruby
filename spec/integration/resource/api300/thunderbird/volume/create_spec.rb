require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    storage_system_data = { credentials: { ip_hostname: $secrets['storage_system1_ip'] } }
    @storage_system = OneviewSDK::API300::Thunderbird::StorageSystem.new($client_300, storage_system_data)
    @storage_system.retrieve!
    @storage_pool = OneviewSDK::API300::Thunderbird::StoragePool.get_all($client_300).first
    @storage_pool.retrieve!
    @vol_template = OneviewSDK::API300::Thunderbird::VolumeTemplate.new($client_300, name: VOL_TEMP_NAME)
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
    #   volume = OneviewSDK::Volume.new($client, options)
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
    #   volume = OneviewSDK::Volume.new($client, options)
    #   volume.create
    # end
    #
    # it 'add volume for management using volume name in storage system' do
    #   options = {
    #     name: VOLUME_NAME,OneviewSDK::Volume
    #     description: 'Integration test volume',
    #     storageSystemUri: @storage_system[:uri],
    #     snapshotPoolUri: @storage_pool[:uri],
    #     provisioningParameters: {
    #       provisionType: 'Full',
    #       storagePoolUri: @storage_pool[:uri],
    #       requestedCapacity: 1024 * 1024 * 1024
    #     }
    #   }
    #   volume = OneviewSDK::Volume.new($client, options)
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
    #   volume = OneviewSDK::Volume.new($client, options)
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
end
