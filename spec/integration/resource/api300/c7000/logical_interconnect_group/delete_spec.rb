require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: LOG_INT_GROUP_NAME)
    @item.retrieve!
    @item_2 = klass.new($client_300, name: LOG_INT_GROUP2_NAME)
    @item_2.retrieve!
    @item_3 = klass.new($client_300, name: LOG_INT_GROUP3_NAME)
    @item_3.retrieve!
    @item_4 = klass.new($client_300, name: LOG_INT_GROUP4_NAME)
    @item_4.retrieve!
  end

  describe '#delete' do
    it 'removes all the Logical Interconnect groups' do
      expect { @item.delete }.to_not raise_error
      expect { @item_2.delete }.to_not raise_error
      expect { @item_3.delete }.to_not raise_error
      expect { @item_4.delete }.to_not raise_error
    end
  end
end
