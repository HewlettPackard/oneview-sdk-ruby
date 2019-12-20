require 'spec_helper'

klass = OneviewSDK::API1200::Synergy::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1000' do
    expect(described_class).to be < OneviewSDK::API1000::Synergy::EnclosureGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_1200)
      expect(item[:enclosureCount]).to eq(1)
      expect(item[:ipAddressingMode]).to eq('DHCP')
    end
  end
end
