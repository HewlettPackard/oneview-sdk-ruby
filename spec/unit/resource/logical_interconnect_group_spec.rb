require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::LogicalInterconnectGroup.new(@client)
      expect(item[:enclosureType]).to eq('C7000')
      expect(item[:state]).to eq('Active')
      expect(item[:uplinkSets]).to eq([])
      expect(item[:type]).to eq('logical-interconnect-groupV3')
      expect(item[:interconnectMapTemplate]).to eq({})
      expect(item[:interconnectBayMap]).to eq({})
    end
  end
end
