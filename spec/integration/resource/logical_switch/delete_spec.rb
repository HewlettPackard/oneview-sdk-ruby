require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitch, integration: true, type: DELETE, sequence: 10 do
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
