require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitch, integration: true, type: UPDATE do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitch.new($client, name: LOG_SWI_NAME)
    @item.retrieve!
  end

  describe '#refresh' do
    it 'refresh logical switch' do
      @item.refresh
    end
  end
end
