require 'spec_helper'

klass = OneviewSDK::API300::Synergy::VolumeAttachment
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.new($client_300_synergy)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '::get_extra_unmanaged_volumes' do
    it 'should get the list of extra unmanaged storage volumes' do
      expect { klass.get_extra_unmanaged_volumes($client_300_synergy) }.to_not raise_error
    end
  end

  describe '::remove_extra_unmanaged_volume' do
    xit 'should remove extra presentations from a specific server profile (Skipping this test because occurs error on the http method of ruby)' do
      server_profile = OneviewSDK::API300::Synergy::ServerProfile.find_by($client_300_synergy, name: SERVER_PROFILE_NAME).first
      expect { klass.remove_extra_unmanaged_volume($client_300_synergy, server_profile) }.to_not raise_error
    end
  end

  describe '#get_paths' do
    it 'should get a list of volume attachment paths from the attachment' do
      item = klass.get_all($client_300_synergy).first
      expect { item.get_paths }.to_not raise_error
    end
  end
end
