require 'spec_helper'

RSpec.describe OneviewSDK::API1000::C7000::ServerProfile do
  include_context 'shared context'

  it 'inherits from API800' do
    expect(described_class).to be < OneviewSDK::API800::C7000::ServerProfile
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_1000, name: 'server_profile')
      expect(item[:type]).to eq('ServerProfileV10')
    end
  end
end
