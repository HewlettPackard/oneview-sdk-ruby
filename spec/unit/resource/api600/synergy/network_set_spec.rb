require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::NetworkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API600::C7000::NetworkSet' do
    expect(described_class).to be < OneviewSDK::API600::C7000::NetworkSet
  end

  describe '#initialize' do
    context 'OneView 4.00' do
      it 'sets the defaults correctly' do
        network_set = described_class.new(@client_600)
        expect(network_set[:type]).to eq('network-setV4')
      end
    end
  end
end
