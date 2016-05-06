require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitchGroup, integration: true, type: DELETE, sequence: 11 do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitchGroup.new($client, name: LOG_SWI_GROUP_NAME)
    @item.retrieve!
  end

  describe '#delete' do
    it 'removes all the Logical Switch groups' do
      expect { @item.delete }.to_not raise_error
    end
  end
end
