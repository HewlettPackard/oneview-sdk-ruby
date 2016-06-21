require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareDriver do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the type correctly' do
      profile = OneviewSDK::FirmwareDriver.new(@client)
      expect(profile[:type]).to eq('firmware-baselines')
    end
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::FirmwareDriver.new(@client, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/is unavailable for this resource/)
    end

  end
end
