require 'spec_helper'

klass = OneviewSDK::LogicalSwitch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitch.new($client, name: LOG_SWI_NAME)
    @item.retrieve!
  end

  describe '#delete' do
    it 'removes Logical Switch' do
      expect { @item.delete }.to_not raise_error
    end
  end
end
