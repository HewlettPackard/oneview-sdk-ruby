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
      item = OneviewSDK::Volume.new(@client_200, name: volume_name)
      item['provisioningParameters'] = provisioning_parameters
      item.create
      expect(item['provisionType']).to eq(provisioning_parameters[:provisionType])
      expect(item['shareable']).to eq(provisioning_parameters[:shareable])
      expect(item['allocatedCapacity']).to eq(provisioning_parameters[:requestedCapacity])
      expect(item['storagePoolUri']).to eq(provisioning_parameters[:storagePoolUri])
    end
  end

  describe '#delete' do
    it 'passes an extra header' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = OneviewSDK::Volume.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_api).with(:delete, '/rest/fake', { 'exportOnly' => true }, item.api_version)
      item.delete(:oneview)
    end
  end

  describe 'helpers' do
    before :each do
      @item = OneviewSDK::Volume.new(@client_200, name: volume_name)
    end

    describe '#set_storage_system' do
      it 'sets the storageSystemUri' do
        @item.set_storage_system(OneviewSDK::StorageSystem.new(@client_200, uri: '/rest/fake'))
        expect(@item['storageSystemUri']).to eq('/rest/fake')
      end
    end

    describe '#set_storage_pool' do
      it 'sets the storagePoolUri' do
        @item.set_storage_pool(OneviewSDK::StoragePool.new(@client_200, uri: '/rest/fake'))
        expect(@item['provisioningParameters']['storagePoolUri']).to eq('/rest/fake')
      end
    end

    describe '#set_storage_volume_template' do
      it 'sets the templateUri' do
        @item.set_storage_volume_template(OneviewSDK::Resource.new(@client_200, uri: '/rest/fake'))
        expect(@item['templateUri']).to eq('/rest/fake')
      end
    end

    describe '#set_snapshot_pool' do
      it 'sets the snapshotPoolUri' do
        @item.set_snapshot_pool(OneviewSDK::StoragePool.new(@client_200, uri: '/rest/fake'))
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
        expect(@client_200).to receive(:rest_post).with("#{@item['uri']}/snapshots", { 'body' => @snapshot_options }, @item.api_version)
      end

      it 'creates the snapshot' do
        @item.create_snapshot(@snapshot_options[:name], @snapshot_options[:description])
      end
    end

    describe '#get_snapshots' do
      it 'gets an array of snapshots' do
        @item['uri'] = '/rest/storage-volumes/fake'
        snapshot_options = { 'type' => 'Snapshot', 'name' => 'Vol1_Snapshot1', 'description' => 'New Snapshot' }
        snapshots = [OneviewSDK::VolumeSnapshot.new(@client_200, snapshot_options)]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => snapshots)
        expect(@client_200).to receive(:rest_get).with("#{@item['uri']}/snapshots", @item.api_version)
        snapshots = @item.get_snapshots
        expect(snapshots.class).to eq(Array)
        expect(snapshots.size).to eq(1)
        expect(snapshots.first['name']).to eq('Vol1_Snapshot1')
      end
    end

    describe '#get_snapshot' do
      it 'get snapshot by name' do
        @item['uri'] = '/rest/storage-volumes/fake'
        snapshot_options = { 'type' => 'Snapshot', 'name' => 'Vol1_Snapshot1', 'description' => 'New Snapshot' }
        snapshots = [OneviewSDK::VolumeSnapshot.new(@client_200, snapshot_options)]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => snapshots)
        expect(@client_200).to receive(:rest_get).with("#{@item['uri']}/snapshots", @item.api_version)
        snapshot = @item.get_snapshot('Vol1_Snapshot1')
        expect(snapshot['type']).to eq('Snapshot')
        expect(snapshot['name']).to eq('Vol1_Snapshot1')
        expect(snapshot['description']).to eq('New Snapshot')
      end
    end

    describe '#delete_snapshot' do
      it 'Deletes a snapshot of the volume' do
        @item['uri'] = '/rest/storage-volumes/fake'
        snapshot_options = { 'uri' => '/rest/fake', 'type' => 'Snapshot', 'name' => 'Vol1_Snapshot1', 'description' => 'New Snapshot' }
        snapshots = [OneviewSDK::VolumeSnapshot.new(@client_200, snapshot_options)]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => snapshots)
        expect(@client_200).to receive(:rest_get).with("#{@item['uri']}/snapshots", @item.api_version)
        expect(@client_200).to receive(:rest_api).with(:delete, '/rest/fake', {}, @item.api_version)
        result = @item.delete_snapshot('Vol1_Snapshot1')
        expect(result).to eq(true)
      end
    end

    describe '#get_attachable_volumes' do
      it 'returns an array of available volumes' do
        volumes = [@item]
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => volumes)
        expect(@client_200).to receive(:rest_get).with('/rest/storage-volumes/attachable-volumes')
        items = OneviewSDK::Volume.get_attachable_volumes(@client_200)
        expect(items.class).to eq(Array)
        expect(items.size).to eq(1)
        expect(items.first['name']).to eq('volume_name')
      end
    end

    describe '#get_extra_managed_volume_paths' do
      it 'gets the list of extra managed storage volume paths' do
        paths = ['%fake1', '%fake2']
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('members' => paths)
        expect(@client_200).to receive(:rest_get).with('/rest/storage-volumes/repair?alertFixType=ExtraManagedStorageVolumePaths')
        results = OneviewSDK::Volume.get_extra_managed_volume_paths(@client_200)
        expect(results['members']).to eq(paths)
      end
    end

    describe '#repair' do
      it 'removes extra presentation from the volume' do
        body = {
          resourceUri: '/rest/storage-volumes',
          type: 'ExtraManagedStorageVolumePaths'
        }
        item = OneviewSDK::Volume.new(@client_200, uri: '/rest/storage-volumes')
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return('response' => 'fake')
        expect(@client_200).to receive(:rest_post).with("#{item['uri']}/repair", 'body' => body).and_return(true)
        response = item.repair
        expect(response['response']).to eq('fake')
      end
    end
  end
end
