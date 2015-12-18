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
      # In this case with the calls stubbed, it will remove them
      allow_any_instance_of(OneviewSDK::Resource).to receive(:create).and_return(true)
      item = OneviewSDK::Volume.new(@client, options)
      item.create
      expect(item.data).to eq('name' => 'FakeVol')
    end
  end

  describe '#delete_from_oneview' do
    it 'passes an extra header' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      item = OneviewSDK::Volume.new(@client, options.merge(uri: '/rest/fake'))
      expect(@client).to receive(:rest_api).with(:delete, '/rest/fake', { 'exportOnly' => true }, item.api_version)
      item.delete_from_oneview
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

    describe '#set_requested_capacity' do
      it 'sets the requestedCapacity' do
        @item.set_requested_capacity(1000)
        expect(@item['requestedCapacity']).to eq(1000)
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
