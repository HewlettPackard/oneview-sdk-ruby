require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareDriver do
  include_context 'shared context'

  describe 'undefined methods' do
    it 'does not allow the update action' do
      item = OneviewSDK::FirmwareDriver.new(@client, {})
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
