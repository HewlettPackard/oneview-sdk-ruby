require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::NetworkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::C7000::NetworkSet' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::NetworkSet
  end

  describe '#initialize' do
    context 'OneView 4.00' do
      it 'sets the defaults correctly' do
        network_set = described_class.new(@client_1200)
        expect(network_set[:type]).to eq('network-setV5')
      end
    end
  end
end
