require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: DELETE, sequence: 11 do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP_NAME)
    @item.retrieve!
    @item_2 = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP2_NAME)
    @item_2.retrieve!
  end

  describe '#delete' do
    it 'removes all the Logical Interconnect groups' do
      expect { @item.delete }.to_not raise_error
      expect { @item_2.delete }.to_not raise_error
    end
  end
end
