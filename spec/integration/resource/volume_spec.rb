require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true do
  include_context 'integration context'

  describe '#create' do
    after(:each) do
      volume = OneviewSDK::Volume.new(@client, name: 'volume_integration_tests')
      volume.retrieve!
      volume.delete if volume['uri']
    end

    it 'create new volume' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        requestedCapacity: 512 * 1024 * 1024
      )
    end
    it 'create volume from a volume template' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        templateUri: '/rest/storage-volume-templates/fadb996b-0a62-482d-a98e-6ff99e22f0b8'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(requestedCapacity: 512 * 1024 * 1024)
    end
    it 'create volume with snapshot pool specified' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        snapshotPoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        requestedCapacity: 512 * 1024 * 1024
      )
    end
    it 'add volume for management' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        requestedCapacity: 512 * 1024 * 1024
      )

      wwn = volume[:wwn]

      # Delete only from oneview
      # volume.delete(:oneview)
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        type: 'AddStorageVolumeV2',
        wwn: wwn
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create

    end
    it 'add volume for management using volume name in storage system' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        snapshotPoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        requestedCapacity: 512 * 1024 * 1024
      )

      storage_system_volume_name = volume[:deviceVolumeName]

      # Delete only from oneview
      volume.delete(:oneview)

      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        storageSystemVolumeName: storage_system_volume_name,
        type: 'AddStorageVolumeV3'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create
    end
    it 'create from volume snapshot' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        snapshotPoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        requestedCapacity: 512 * 1024 * 1024
      )

      volume.create_snapshot('snapshot_qa')
      snap = volume.snapshot('snapshot_qa')

      options = {
        type: 'AddStorageVolumeV3',
        name: 'volume_integration_tests_02',
        description: 'Integration test volume 02',
        snapshotPoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        snapshotUri: "#{volume[:uri]}/snapshots/#{snap['uri']}"
      }
      volume_02 = OneviewSDK::Volume.new(@client, options)
      volume_02.create(storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9')
      volume_02.delete

    end
  end


  describe '#snapshot' do
    it 'create' do
      options = {
        name: 'volume_integration_tests',
        description: 'Integration test volume',
        storageSystemUri: '/rest/storage-systems/TXQ1000307',
        snapshotPoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9'
      }
      volume = OneviewSDK::Volume.new(@client, options)
      volume.create(
        provisionType: 'Full',
        storagePoolUri: '/rest/storage-pools/F1601B06-280D-4EA3-8ACF-FA86234A17F9',
        requestedCapacity: 512 * 1024 * 1024
      )
      expect { volume.create_snapshot('snapshot_qa') }.not_to raise_error
    end
    it 'retrieve list' do
      volume = OneviewSDK::Volume.new(@client, name: 'volume_integration_tests')
      volume.retrieve!
      expect(volume.snapshots).not_to be_empty
    end
    it 'retrieve by name' do
      volume = OneviewSDK::Volume.new(@client, name: 'volume_integration_tests')
      volume.retrieve!
      expect(volume.snapshot('snapshot_qa')).not_to be_empty
    end
    it 'delete' do
      volume = OneviewSDK::Volume.new(@client, name: 'volume_integration_tests')
      volume.retrieve!
      volume.delete_snapshot('snapshot_qa')
      volume.delete
    end
  end

end
