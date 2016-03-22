require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: CREATE, sequence: 12 do
  include_context 'integration context'

  before :all do
    storage_system_data = { credentials: { ip_hostname: $secrets['storage_system1_ip'] } }
    @storage_system = OneviewSDK::StorageSystem.new($client, storage_system_data)
    @storage_system.retrieve!
    @storage_pool = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
    @storage_pool.retrieve!
    @vol_template = OneviewSDK::VolumeTemplate.new($client, name: VOL_TEMP_NAME)
  end

  describe '#create' do
    before :each do
      volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
      volume.delete if volume.retrieve!
    end

    it 'create new volume' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri]
      }
      volume = OneviewSDK::Volume.new($client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: @storage_pool[:uri],
        requestedCapacity: 512 * 1024 * 1024
      )
    end

    it 'create volume from a volume template' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        templateUri: @vol_template[:uri]
      }
      volume = OneviewSDK::Volume.new($client, options)
      volume.create(requestedCapacity: 512 * 1024 * 1024)
    end

    it 'create volume with snapshot pool specified' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        snapshotPoolUri: @storage_pool[:uri]
      }
      volume = OneviewSDK::Volume.new($client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: @storage_pool[:uri],
        requestedCapacity: 512 * 1024 * 1024
      )
    end

    it 'add volume for management' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri]
      }
      volume = OneviewSDK::Volume.new($client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: @storage_pool[:uri],
        requestedCapacity: 512 * 1024 * 1024
      )

      wwn = volume[:wwn]

      # Delete only from oneview
      volume.delete(:oneview)
      
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        type: 'AddStorageVolumeV2',
        wwn: wwn
      }
      volume = OneviewSDK::Volume.new($client, options)
      volume.create
    end

    # it 'add volume for management using volume name in storage system' do
    #   options = {
    #     name: VOLUME_NAME,
    #     description: 'Integration test volume',
    #     storageSystemUri: @storage_system[:uri],
    #     snapshotPoolUri: @storage_pool[:uri]
    #   }
    #   volume = OneviewSDK::Volume.new($client, options)
    #   volume.create(
    #     provisionType: 'Full',
    #     storagePoolUri: @storage_pool[:uri],
    #     requestedCapacity: 512 * 1024 * 1024
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

    it 'create from volume snapshot' do
      options = {
        name: VOLUME_NAME,
        description: 'Integration test volume',
        storageSystemUri: @storage_system[:uri],
        snapshotPoolUri: @storage_pool[:uri]
      }
      volume = OneviewSDK::Volume.new($client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: @storage_pool[:uri],
        requestedCapacity: 512 * 1024 * 1024
      )

      volume.create_snapshot(VOL_SNAPSHOT_NAME)
      snap = volume.snapshot(VOL_SNAPSHOT_NAME)

      options = {
        type: 'AddStorageVolumeV3',
        name: VOLUME2_NAME,
        description: 'Integration test volume 2',
        snapshotPoolUri: @storage_pool[:uri],
        storageSystemUri: @storage_system[:uri],
        snapshotUri: "#{volume[:uri]}/snapshots/#{snap['uri']}"
      }
      volume_2 = OneviewSDK::Volume.new($client, options)
      volume_2.create(storagePoolUri: @storage_pool[:uri])
      volume_2.delete
    end
  end
end
