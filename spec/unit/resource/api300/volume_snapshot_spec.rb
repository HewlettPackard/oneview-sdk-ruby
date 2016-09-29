require 'spec_helper'

RSpec.describe OneviewSDK::API300::VolumeSnapshot do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::VolumeSnapshot
  end

  let(:options) do
    {
      type: 'Snapshot',
      name: '{volumeName}_{timestamp}',
      description: 'New snapshot'
    }
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      template = OneviewSDK::API300::VolumeSnapshot.new(@client_300)
      expect(template[:type]).to eq('Snapshot')
    end
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::API300::VolumeSnapshot.new(@client_300, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end

  end

  describe 'helpers' do
    before :each do
      @item = OneviewSDK::API300::VolumeSnapshot.new(@client_300, options)
    end

    describe '#set_volume' do
      it 'sets the storageVolumeUri' do
        @item.set_volume(OneviewSDK::Volume.new(@client_300, uri: '/rest/storage-volumes/fake'))
        expect(@item['storageVolumeUri']).to eq('/rest/storage-volumes/fake')
      end

      it 'requires a storage_volume with a uri' do
        vol = OneviewSDK::Volume.new(@client_300)
        expect { @item.set_volume(vol) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
      end
    end
  end

end
