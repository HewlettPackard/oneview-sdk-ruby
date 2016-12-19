require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: LOG_SWI_NAME)
    @item.retrieve!
  end

  describe '#delete' do
    it 'removes Logical Switch' do
      expect { @item.delete }.to_not raise_error
    end
  end
end
