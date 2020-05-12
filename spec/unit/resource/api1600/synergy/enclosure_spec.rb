require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::Enclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::Synergy::Enclosure' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::Enclosure
  end

  describe '#initialize' do
    context 'OneView 5.00' do
      it 'sets the defaults correctly' do
        enclosure = described_class.new(@client_1600)
        expect(enclosure[:type]).to eq('EnclosureV8')
      end
    end
  end
end
