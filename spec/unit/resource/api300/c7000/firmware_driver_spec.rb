require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::FirmwareDriver do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::FirmwareDriver
  end

  describe '#remove' do
    it 'Should support remove' do
      firmware = OneviewSDK::API300::C7000::FirmwareDriver.new(@client_300, uri: '/rest/firmware-drivers/100')
      expect(@client_300).to receive(:rest_delete).with('/rest/firmware-drivers/100', {}, 300).and_return(FakeResponse.new({}))
      firmware.remove
    end
  end

  describe 'undefined methods' do
    it 'does not allow the update action' do
      item = OneviewSDK::API300::C7000::FirmwareDriver.new(@client_300, {})
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end

    it 'does not allow the delete action' do
      item = OneviewSDK::API300::C7000::FirmwareDriver.new(@client_300, {})
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
