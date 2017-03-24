require 'spec_helper'

klass = OneviewSDK::ServerProfile
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes all the resources' do
      names = [SERVER_PROFILE_NAME, SERVER_PROFILE2_NAME, SERVER_PROFILE3_NAME]
      names.each do |name|
        item = OneviewSDK::ServerProfile.find_by($client, 'name' => name).first
        expect(item).to be
        expect { item.delete }.to_not raise_error
      end
      assoc_vol = OneviewSDK::Volume.find_by($client, 'name' => VOLUME4_NAME).first
      expect { assoc_vol.delete }.to_not raise_error
    end

    it 'should delete the Server Profile created with OS Deployment Plan (it will fail if the there is not a OS Deployment Plan)' do
      item = OneviewSDK::ServerProfile.find_by($client, 'name' => SERVER_PROFILE_WITH_OSDP_NAME).first
      expect(item).to be
      expect { item.delete }.to_not raise_error
    end
  end
end
