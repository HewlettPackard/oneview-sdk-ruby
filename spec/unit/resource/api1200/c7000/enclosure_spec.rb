require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::Enclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::C7000::Enclosure' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::Enclosure
  end

  describe '#initialize' do
    context 'OneView 5.00' do
      it 'sets the defaults correctly' do
        enclosure = described_class.new(@client_1200)
        expect(enclosure[:type]).to eq('EnclosureV8')
      end
    end
  end
end
