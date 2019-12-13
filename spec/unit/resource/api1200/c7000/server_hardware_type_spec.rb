require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::ServerHardwareType do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::C7000::ServerHardwareType' do
    expect(described_class).to be < OneviewSDK::API800::C7000::ServerHardwareType
  end
  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1200)
      expect(item['type']).to eq('server-hardware-type-10')
    end
  end
end
