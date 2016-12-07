require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeAttachment
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  # Create operation should be performed through the Server-Profiles API
  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.new($client_300)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '::get_all' do
    it 'should get all volume attachments' do
      items = klass.get_all($client_300)
      expect(items).not_to be_empty
    end
  end

  describe '::find_by' do
    context 'with no parameters' do
      it 'should get all volume attachments' do
        items = klass.find_by($client_300, {})
        expect(items).not_to be_empty
      end
    end

    context 'with parameters' do
      it 'should get volume attachments by filter applied' do
        volume = OneviewSDK::API300::C7000::Volume.new($client_300, name: VOLUME_NAME)
        volume.retrieve!

        params = { 'storageVolumeUri' => volume['uri'] }
        items = klass.find_by($client_300, params)

        expect(items).not_to be_empty
      end

      context 'when parameters is wrong' do
        it 'should get empty list' do
          params = { 'storageVolumeUri' => 'wrongValue' }
          items = klass.find_by($client_300, params)

          expect(items).to be_empty
        end
      end
    end
  end

  describe '::get_extra_unmanaged_volumes' do
    it 'should get the list of extra unmanaged storage volumes' do
      expect { klass.get_extra_unmanaged_volumes($client_300) }.to_not raise_error
    end
  end

  describe '::remove_extra_unmanaged_volume' do
    xit 'should remove extra presentations from a specific server profile (Skipping this test because occurs error on the http method of ruby)' do
      server_profile = OneviewSDK::API300::C7000::ServerProfile.find_by($client_300, name: SERVER_PROFILE_NAME).first
      expect { klass.remove_extra_unmanaged_volume($client_300, server_profile) }.to_not raise_error
    end
  end

  describe 'retrieve!' do
    it 'should get a volume attachment by uri' do
      item = klass.get_all($client_300).first

      expected_item = klass.new($client_300, uri: item['uri'])
      expected_item.retrieve!

      expect(expected_item).to eq(item)
    end
  end

  describe '#get_paths' do
    it 'should get a list of volume attachment paths from the attachment' do
      item = klass.get_all($client_300).first
      expect { item.get_paths }.to_not raise_error
    end
  end

  # describe '#get_path' do
  #   it 'should get a particular storage volume attachment path' do
  #     # TODO should refactor this test for better expectation
  #     item = klass.get_all($client_300).first
  #     path = item.get_paths.first
  #     expect { item.get_path(path['id']) }# TODO should refactor this test for better expectation
  #   end
  # end
end
