require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: LOG_SWI_GROUP_NAME)
    @item.retrieve!
  end

  describe '#delete' do
    it 'removes all the Logical Switch groups' do
      expect { @item.delete }.to_not raise_error
      item = klass.find_by($client_300, name: LOG_SWI_GROUP_NAME)
      expect(item).to be_empty
    end
  end
end
