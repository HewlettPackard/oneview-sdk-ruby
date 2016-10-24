require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::ServerProfile
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'deletes all the resources' do
      names = [SERVER_PROFILE_NAME, SERVER_PROFILE2_NAME, SERVER_PROFILE3_NAME]
      names.each do |name|
        item = klass.find_by($client_300, 'name' => name).first
        expect(item).to be
        expect { item.delete }.to_not raise_error
      end
      assoc_vol = OneviewSDK::API300::Thunderbird::Volume.find_by($client_300, 'name' => VOLUME4_NAME).first
      expect { assoc_vol.delete }.to_not raise_error
    end
  end
end
