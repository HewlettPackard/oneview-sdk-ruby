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
    context 'OneView 1.2' do
      it 'does not exist for OV < 200' do
        expect { OneviewSDK::VolumeSnapshot.new(@client_120) }.to raise_error(/only exist on api version >= 200/)
      end
    end

    context 'OneView 2.0' do
      it 'sets the type correctly' do
        template = OneviewSDK::VolumeSnapshot.new(@client)
        expect(template[:type]).to eq('Snapshot')
      end
    end
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::VolumeSnapshot.new(@client, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the save action' do
      expect { @item.save }.to raise_error(/not available for this resource/)
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
