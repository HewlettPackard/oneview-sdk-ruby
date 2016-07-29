require 'spec_helper'

klass = OneviewSDK::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP_NAME)
    @item.retrieve!
    @item_2 = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP2_NAME)
    @item_2.retrieve!
    @item_3 = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP3_NAME)
    @item_3.retrieve!
  end

  describe '#delete' do
    it 'removes all the Logical Interconnect groups' do
      expect { @item.delete }.to_not raise_error
      expect { @item_2.delete }.to_not raise_error
      expect { @item_3.delete }.to_not raise_error
    end
  end
end
