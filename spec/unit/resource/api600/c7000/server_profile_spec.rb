require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::ServerProfile do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::API300::C7000::ServerProfile
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_500, name: 'server_profile')
      expect(item[:type]).to eq('ServerProfileV7')
    end
  end

  describe '#create_volume_with_attachment' do
    let(:storage_pool_class) { OneviewSDK::API500::C7000::StoragePool }
    let(:storage_pool) { storage_pool_class.new(@client_500, uri: 'fake/storage-pool') }

    before :each do
      @item = described_class.new(@client_500, name: 'server_profile')
    end

    it 'raises an exception when storage pool not found' do
      allow_any_instance_of(storage_pool_class).to receive(:retrieve!).and_return(false)
      expect { @item.create_volume_with_attachment(storage_pool, {}) }.to raise_error(/Storage Pool not found/)
    end

    it 'can call #create_volume_with_attachment and generate the data required for a new Volume with attachment' do
      volume_options = {
        name: 'Volume Test',
        description: 'Volume store serv',
        size: 1024 * 1024 * 1024,
        provisioningType: 'Thin',
        isShareable: false
      }

      allow_any_instance_of(storage_pool_class).to receive(:retrieve!).and_return(true)
      @item.create_volume_with_attachment(storage_pool, volume_options)
      expect(@item['sanStorage']['volumeAttachments'].size).to eq(1)
      va = @item['sanStorage']['volumeAttachments'].first
      expect(va['volumeUri']).not_to be
      expect(va['volumeStorageSystemUri']).not_to be
      expect(va['volumeStoragePoolUri']).to eq('fake/storage-pool')
      expect(va['volumeShareable']).to eq(false)
      expect(va['volumeProvisionedCapacityBytes']).to eq(1024 * 1024 * 1024)
      expect(va['volumeProvisionType']).to eq('Thin')
    end
  end

  describe '#get_profile_template' do
    it 'getting a new template from server profile' do
      fake_response = FakeResponse.new(enclosureGroupUri: '/rest/fake2')
      expect(@client_500).to receive(:rest_get).with('rest/fake/new-profile-template').and_return(fake_response)
      item = described_class.new(@client_500, name: 'server_profile', uri: 'rest/fake')
      new_template = item.get_profile_template
      expect(new_template['enclosureGroupUri']).to eq('/rest/fake2')
    end
  end
end
