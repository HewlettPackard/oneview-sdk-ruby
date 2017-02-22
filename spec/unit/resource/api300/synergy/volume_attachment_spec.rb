require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::VolumeAttachment do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::VolumeAttachment
  end

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 300' do
      item = OneviewSDK::API300::Synergy::VolumeAttachment.new(@client_300)
      expect(item[:type]).to eq('StorageVolumeAttachment')
    end
  end

  describe 'Unmanaged Storage volumes' do
    it 'remove' do
      options = { type: 'ExtraUnmanagedStorageVolumes', resourceUri: '/rest/server-profiles/1' }
      expect(@client_300).to receive(:rest_post).with(
        '/rest/storage-volume-attachments/repair',
        { 'Accept-Language' => 'en_US', 'body' => options },
        @client_300.api_version
      ).and_return(FakeResponse.new({}))
      OneviewSDK::API300::Synergy::VolumeAttachment.remove_extra_unmanaged_volume(@client_300, 'uri' => '/rest/server-profiles/1')
    end

    it 'list' do
      expect(@client_300).to receive(:rest_get).with('/rest/storage-volume-attachments/repair?alertFixType=ExtraUnmanagedStorageVolumes')
        .and_return(FakeResponse.new({}))
      OneviewSDK::API300::Synergy::VolumeAttachment.get_extra_unmanaged_volumes(@client_300)
    end
  end

  describe '#path' do
    it 'retrieve by id' do
      expect(@client_300).to receive(:rest_get).with('/rest/storage-volume-attachments/volume_attach_1/paths/volume_path_1')
        .and_return(FakeResponse.new({}))
      item = OneviewSDK::API300::Synergy::VolumeAttachment.new(@client_300, uri: '/rest/storage-volume-attachments/volume_attach_1')
      item.get_path('volume_path_1')
    end

    it 'get list' do
      expect(@client_300).to receive(:rest_get).with('/rest/storage-volume-attachments/volume_attach_1/paths')
        .and_return(FakeResponse.new({}))
      item = OneviewSDK::API300::Synergy::VolumeAttachment.new(@client_300, uri: '/rest/storage-volume-attachments/volume_attach_1')
      item.get_paths
    end
  end

  describe 'unavailable methods' do
    it 'create' do
      item = OneviewSDK::API300::Synergy::VolumeAttachment.new(@client_300, uri: '/rest/storage-volume-attachments/volume_attach_1')
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
    it 'update' do
      item = OneviewSDK::API300::Synergy::VolumeAttachment.new(@client_300, uri: '/rest/storage-volume-attachments/volume_attach_1')
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
    it 'delete' do
      item = OneviewSDK::API300::Synergy::VolumeAttachment.new(@client_300, uri: '/rest/storage-volume-attachments/volume_attach_1')
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

end
