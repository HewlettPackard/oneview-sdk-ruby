require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitchGroup, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'renaming the Logical Switch Group' do
      item = OneviewSDK::LogicalSwitchGroup.new($client, name: LOG_SWI_GROUP_NAME)
      item.retrieve!
      expect { item.update(name: LOG_SWI_GROUP_NAME_UPDATED) }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(LOG_SWI_GROUP_NAME_UPDATED)
      expect { item.update(name: LOG_SWI_GROUP_NAME) }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(LOG_SWI_GROUP_NAME)
    end
  end
end
