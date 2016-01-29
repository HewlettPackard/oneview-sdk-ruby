require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::LogicalInterconnectGroup.new(@client)
      expect(item[:enclosureType]).to eq('C7000')
      expect(item[:state]).to eq('Active')
      expect(item[:uplinkSets]).to eq([])
      expect(item[:type]).to eq('logical-interconnect-groupV3')
      path = 'spec/support/fixtures/unit/resource/lig_default_templates.json'
      expect(item[:interconnectMapTemplate]).to eq(JSON.parse(File.read(path)))
    end
  end
end
