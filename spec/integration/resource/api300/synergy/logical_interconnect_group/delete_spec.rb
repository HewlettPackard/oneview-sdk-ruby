require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: LOG_INT_GROUP_NAME)
    @item.retrieve!
    @item_2 = klass.new($client_300, name: LOG_INT_GROUP2_NAME)
    @item_2.retrieve!
  end

  describe '#delete' do
    it 'removes all the Logical Interconnect groups' do
      expect { @item.delete }.to_not raise_error
      expect { @item_2.delete }.to_not raise_error
    end
  end
end
