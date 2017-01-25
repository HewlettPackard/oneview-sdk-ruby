require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitch, integration: true, type: UPDATE do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitch.new($client, name: LOG_SWI_NAME)
    @item.retrieve!
  end

  describe '#refresh_state' do
    it 'should reclaims the top-of-rack switches in a logical switch' do
      expect { @item.refresh_state }.to_not raise_error
    end
  end
end
