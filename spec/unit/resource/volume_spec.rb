require 'spec_helper'

RSpec.describe OneviewSDK::Volume do
  include_context 'shared context'

  let(:options) do
    {
      name: 'FakeVol',
      provisionType: 'Full',
      shareable: true,
      storagePoolUri: '/rest/fake',
      requestedCapacity: 1024
    }
  end

  describe '#create' do
    it 'rearranges the provisioningParameters' do
      pending('Waiting on Issue #52: Volume repair endpoint') # TODO
      # In this case with the calls stubbed, it will remove them
      item = OneviewSDK::Volume.new(@client, options)
      allow(item).to receive(:create).and_return(true)
      item.create
      expect(item.data).to eq('name' => 'FakeVol') # TODO
    end
  end

  describe '#delete' do
    it 'passes an extra header' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = OneviewSDK::Volume.new(@client, options.merge(uri: '/rest/fake'))
      expect(@client).to receive(:rest_api).with(:delete, '/rest/fake', { 'exportOnly' => true }, item.api_version)
      item.delete(:oneview)
    end
  end

  describe 'helpers' do
    before :each do
      @item = OneviewSDK::Volume.new(@client, options)
    end

    describe '#set_storage_system' do
      it 'sets the storageSystemUri' do
        @item.set_storage_system(OneviewSDK::StorageSystem.new(@client, uri: '/rest/fake'))
        expect(@item['storageSystemUri']).to eq('/rest/fake')
      end
    end

    describe '#set_storage_pool' do
      it 'sets the storagePoolUri' do
        @item.set_storage_pool(OneviewSDK::StoragePool.new(@client, uri: '/rest/fake'))
        expect(@item['storagePoolUri']).to eq('/rest/fake')
      end
    end

    describe '#set_storage_volume_template' do
      it 'sets the templateUri' do
        @item.set_storage_volume_template(OneviewSDK::Resource.new(@client, uri: '/rest/fake'))
        expect(@item['templateUri']).to eq('/rest/fake')
      end
    end

    describe '#set_snapshot_pool' do
      it 'sets the snapshotPoolUri' do
        @item.set_snapshot_pool(OneviewSDK::StoragePool.new(@client, uri: '/rest/fake'))
        expect(@item['snapshotPoolUri']).to eq('/rest/fake')
      end
    end

    describe '#create_snapshot' do
      before :each do
        @snapshot_options = {
          type: 'Snapshot',
          name: 'Vol1_Snapshot1',
          description: 'New Snapshot'
        }
        @item['uri'] = '/rest/storage-volumes/fake'
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
        expect(@client).to receive(:rest_post).with("#{@item['uri']}/snapshots", { 'body' => @snapshot_options }, @item.api_version)
      end

      it 'creates the snapshot from a hash' do
        @item.create_snapshot(@snapshot_options)
      end

      it 'creates the snapshot from a VolumeSnapshot object' do
        @item.create_snapshot(OneviewSDK::VolumeSnapshot.new(@client, @snapshot_options))
      end
    end

    describe '#snapshots' do
      it 'gets an array of snapshots' do
        @item['uri'] = '/rest/storage-volumes/fake'
        snapshot_options = { 'type' => 'Snapshot', 'name' => 'Vol1_Snapshot1', 'description' => 'New Snapshot' }
        snapshots = [OneviewSDK::VolumeSnapshot.new(@client, snapshot_options)]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => snapshots)
        expect(@client).to receive(:rest_get).with("#{@item['uri']}/snapshots", @item.api_version)
        snapshots = @item.snapshots
        expect(snapshots.class).to eq(Array)
        expect(snapshots.size).to eq(1)
        expect(snapshots.first['name']).to eq('Vol1_Snapshot1')
      end
    end

    describe '#set_requested_capacity' do
      it 'sets the requestedCapacity' do
        @item.set_requested_capacity(1000)
        expect(@item['requestedCapacity']).to eq(1000)
      end
    end

    describe '#attachable_volumes' do
      it 'returns an array of available volumes' do
        volumes = [@item]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => volumes)
        expect(@client).to receive(:rest_get).with('/rest/storage-volumes/attachable-volumes')
        items = OneviewSDK::Volume.attachable_volumes(@client)
        expect(items.class).to eq(Array)
        expect(items.size).to eq(1)
        expect(items.first['name']).to eq('FakeVol')
      end
    end
  end

  describe '#validate' do
    it 'validates provisionType' do
      vol = OneviewSDK::Volume.new(@client, {})
      expect { vol['provisionType'] = 'N/A' }.to raise_error(/Invalid provision type/)
    end
  end

end
