require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::Interconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::Interconnect' do
    expect(described_class).to be < OneviewSDK::API500::C7000::Interconnect
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_600)
      expect(item['type']).to eq('InterconnectV4')
    end
  end
end
