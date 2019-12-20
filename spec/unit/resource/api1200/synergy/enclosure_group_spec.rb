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
      expect(enclosure[:type]).to eq('EnclosureGroupV8')
    end
  end
end
