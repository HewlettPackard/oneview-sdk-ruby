require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareDriver do
  include_context 'shared context'

  describe '#remove' do
    it 'Should support remove' do
      firmware = OneviewSDK::FirmwareDriver.new(@client, uri: '/rest/firmware-drivers/100')
      expect(@client).to receive(:rest_delete).with('/rest/firmware-drivers/100', {}, 200).and_return(FakeResponse.new({}))
      firmware.remove
    end
  end

  describe 'undefined methods' do
    it 'does not allow the update action' do
      item = OneviewSDK::FirmwareDriver.new(@client, {})
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end

    it 'does not allow the delete action' do
      item = OneviewSDK::FirmwareDriver.new(@client, {})
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
