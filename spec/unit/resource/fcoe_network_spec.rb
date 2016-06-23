require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = described_class.new(@client)
      expect(item[:type]).to eq('fcoe-network')
      expect(item[:connectionTemplateUri]).to eq(nil)
    end
  end

  describe 'validations' do
    it 'validates vlanId' do
      described_class::VALID_VLAN_IDS.each do |i|
        expect { described_class.new(@client, vlanId: i) }.to_not raise_error
      end
      expect { described_class.new(@client, vlanId: 0) }.to raise_error(OneviewSDK::InvalidResource, /vlanId out of range/)
    end
  end
end
