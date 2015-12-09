require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardwareType do
  include_context 'shared context'

  describe '#initialize' do
    context 'with OneView 1.2' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::ServerHardwareType.new(@client_120)
        expect(item[:type]).to eq('server-hardware-type-3')
      end
    end

    context 'with OneView 2.0' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::ServerHardwareType.new(@client)
        expect(item[:type]).to eq('server-hardware-type-4')
      end
    end
  end

  describe '#create' do
    it 'does not allow it' do
      item = OneviewSDK::ServerHardwareType.new(@client)
      expect { item.create }.to raise_error(/Method not available/)
    end
  end
end
