require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::UplinkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::C7000::UplinkSet' do
    expect(described_class).to be < OneviewSDK::API800::C7000::UplinkSet
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1200)
      expect(item['type']).to eq('uplink-setV5')
    end
  end
end
