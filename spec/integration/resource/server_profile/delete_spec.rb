require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfile, integration: true, type: DELETE, sequence: 2 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes all the resources' do
      names = [SERVER_PROFILE_NAME, SERVER_PROFILE2_NAME]
      names.each do |name|
        item = OneviewSDK::ServerProfile.find_by($client, 'name' => name).first
        expect(item).to be
        expect { item.delete }.to_not raise_error
      end
    end
  end
end
