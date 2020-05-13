require 'spec_helper'

klass = OneviewSDK::API1600::Synergy::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1200' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::EnclosureGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_1600)
      expect(item[:enclosureCount]).to eq(1)
      expect(item[:ipAddressingMode]).to eq('DHCP')
    end
  end
end
