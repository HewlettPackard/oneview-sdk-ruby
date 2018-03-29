require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ServerProfile do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ServerProfile
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_600, name: 'server_profile')
      expect(item[:type]).to eq('ServerProfileV8')
    end
  end
end
