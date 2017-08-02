require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::ServerProfile do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::ServerProfile
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_300)
      expect(item[:type]).to eq('ServerProfileV6')
    end
  end
end
