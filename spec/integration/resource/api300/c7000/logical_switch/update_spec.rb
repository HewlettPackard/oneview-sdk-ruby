require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: LOG_SWI_NAME)
    @item.retrieve!
  end

  describe '#refresh' do
    it 'refresh logical switch' do
      @item.refresh
    end
  end
end
