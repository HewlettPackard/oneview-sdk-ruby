require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#snapshot' do
    it 'create' do
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
      expect { volume.create_snapshot(VOL_SNAPSHOT_NAME) }.not_to raise_error
    end

    it 'retrieve list' do
      volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
      volume.retrieve!
      expect(volume.snapshots).not_to be_empty
    end

    it 'retrieve by name' do
      volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
      volume.retrieve!
      expect(volume.snapshot(VOL_SNAPSHOT_NAME)).not_to be_empty
    end

    it 'delete' do
      volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
      volume.retrieve!
      volume.delete_snapshot(VOL_SNAPSHOT_NAME)
    end
  end
end
