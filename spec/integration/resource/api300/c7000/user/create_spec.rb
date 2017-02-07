require 'spec_helper'

klass = OneviewSDK::API300::C7000::User
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'can create resources' do
      options = {
        userName: USER_NAME,
        password: 'secret123',
        emailAddress: 'test_user@hpe.com',
        fullName: 'Test User',
        roles: ['Read only']
      }

      item = klass.new($client, options)

      expect { item.create }.to_not raise_error
      expect(item[:userName]).to eq(USER_NAME)
      expect(item[:emailAddress]).to eq('test_user@hpe.com')
      expect(item[:fullName]).to eq('Test User')
      expect(item[:roles]).to eq(['Read only'])
    end
  end
end
