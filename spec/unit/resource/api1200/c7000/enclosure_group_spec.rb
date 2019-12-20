require 'spec_helper'

klass = OneviewSDK::API1200::C7000::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1000' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::EnclosureGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      enclosure_group = described_class.new(@client_1200)
      expect(enclosure_group[:type]).to eq('EnclosureGroupV8')
    end
  end
end
