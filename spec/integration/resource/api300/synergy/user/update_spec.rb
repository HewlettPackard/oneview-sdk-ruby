require 'spec_helper'

klass = OneviewSDK::API300::Synergy::User
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    subject(:item) { klass.find_by($client, userName: USER_NAME).first }

    before do
      expect(item.retrieve!).to eq(true)
    end

    it 'can update resources' do
      item.set_all(
        password: 'secret456',
        emailAddress: 'new_email@hpe.com',
        fullName: 'New Name',
        roles: ['Network administrator', 'Storage administrator']
      )
      expect { item.update }.not_to raise_error
      expect(item['emailAddress']).to eq 'new_email@hpe.com'
      expect(item['fullName']).to eq 'New Name'
      expect(item['roles']).to eq ['Network administrator', 'Storage administrator']
    end
  end
end
