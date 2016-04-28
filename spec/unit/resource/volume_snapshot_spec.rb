require 'spec_helper'

RSpec.describe OneviewSDK::VolumeSnapshot do
  include_context 'shared context'

  let(:options) do
    {
      type: 'Snapshot',
      name: '{volumeName}_{timestamp}',
      description: 'New snapshot'
    }
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      template = OneviewSDK::VolumeSnapshot.new(@client)
      expect(template[:type]).to eq('Snapshot')
    end
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::VolumeSnapshot.new(@client, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end

  end

  describe 'helpers' do
    before :each do
      @item = OneviewSDK::VolumeSnapshot.new(@client, options)
    end

    describe '#set_volume' do
      it 'sets the storageVolumeUri' do
        @item.set_volume(OneviewSDK::Volume.new(@client, uri: '/rest/storage-volumes/fake'))
        expect(@item['storageVolumeUri']).to eq('/rest/storage-volumes/fake')
      end
    end
  end

end
