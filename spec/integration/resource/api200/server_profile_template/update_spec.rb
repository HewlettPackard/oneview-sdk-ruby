require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfileTemplate, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'updates the name attribute' do
      item = OneviewSDK::ServerProfileTemplate.new($client, name: SERVER_PROFILE_TEMPLATE_NAME)
      item.retrieve!
      expect { item.update(name: SERVER_PROFILE_TEMPLATE_NAME_UPDATED) }.not_to raise_error
      expect(item.retrieve!).to be
      expect { item.update(name: SERVER_PROFILE_TEMPLATE_NAME) }.not_to raise_error
      expect(item.retrieve!).to be
      expect(item['name']).to eq(SERVER_PROFILE_TEMPLATE_NAME)
    end
  end
end
