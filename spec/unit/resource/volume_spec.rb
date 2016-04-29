require 'spec_helper'

RSpec.describe OneviewSDK::Volume do
  include_context 'shared context'

  let(:volume_name) { 'volume_name' }
  let(:provisioning_parameters) do
    {
      provisionType: 'Full',
      shareable: true,
      storagePoolUri: '/rest/fake',
      requestedCapacity: 1024
    }
  end

  describe '#create' do
    it 'rearranges the provisioningParameters' do
      allow_any_instance_of(OneviewSDK::Resource).to receive(:create).and_return(true)
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(true)
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(
        name: volume_name,
        provisionType: provisioning_parameters[:provisionType],
        shareable: provisioning_parameters[:shareable],
        allocatedCapacity: provisioning_parameters[:requestedCapacity],
        storagePoolUri: provisioning_parameters[:storagePoolUri],
        uri: '/rest/fake'
      )
      item = OneviewSDK::Volume.new(@client, name: volume_name)
      item.create(provisioning_parameters)
      expect(item['provisionType']).to eq(provisioning_parameters[:provisionType])
      expect(item['shareable']).to eq(provisioning_parameters[:shareable])
      expect(item['allocatedCapacity']).to eq(provisioning_parameters[:requestedCapacity])
      expect(item['storagePoolUri']).to eq(provisioning_parameters[:storagePoolUri])
    end
  end

  describe '#delete' do
    it 'passes an extra header' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = OneviewSDK::Volume.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_api).with(:delete, '/rest/fake', { 'exportOnly' => true }, item.api_version)
      item.delete(:oneview)
    end
  end

  describe 'helpers' do
    before :each do
      @item = OneviewSDK::Volume.new(@client, name: volume_name)
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

      it 'creates the snapshot' do
        @item.create_snapshot(@snapshot_options[:name], @snapshot_options[:description])
      end
    end

    describe '#get_snapshots' do
      it 'gets an array of snapshots' do
        @item['uri'] = '/rest/storage-volumes/fake'
        snapshot_options = { 'type' => 'Snapshot', 'name' => 'Vol1_Snapshot1', 'description' => 'New Snapshot' }
        snapshots = [OneviewSDK::VolumeSnapshot.new(@client, snapshot_options)]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => snapshots)
        expect(@client).to receive(:rest_get).with("#{@item['uri']}/snapshots", @item.api_version)
        snapshots = @item.get_snapshots
        expect(snapshots.class).to eq(Array)
        expect(snapshots.size).to eq(1)
        expect(snapshots.first['name']).to eq('Vol1_Snapshot1')
      end
    end

    describe '#get_attachable_volumes' do
      it 'returns an array of available volumes' do
        volumes = [@item]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => volumes)
        expect(@client).to receive(:rest_get).with('/rest/storage-volumes/attachable-volumes')
        items = OneviewSDK::Volume.get_attachable_volumes(@client)
        expect(items.class).to eq(Array)
        expect(items.size).to eq(1)
        expect(items.first['name']).to eq('volume_name')
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
