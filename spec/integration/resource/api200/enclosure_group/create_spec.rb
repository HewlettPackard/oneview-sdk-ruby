require 'spec_helper'

klass = OneviewSDK::EnclosureGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  let(:enclosure_group_options) do
    {
      'name' => ENC_GROUP_NAME,
      'stackingMode' => 'Enclosure',
      'interconnectBayMappingCount' => 8,
      'type' => 'EnclosureGroupV200'
    }
  end
  let(:enclosure_group_options_2) do
    {
      'name' => ENC_GROUP2_NAME,
      'stackingMode' => 'Enclosure',
      'interconnectBayMappingCount' => 8,
      'type' => 'EnclosureGroupV200'
    }
  end
  let(:enclosure_group_options_3) do
    {
      'name' => ENC_GROUP3_NAME,
      'stackingMode' => 'Enclosure',
      'interconnectBayMappingCount' => 8,
      'type' => 'EnclosureGroupV200'
    }
  end

  describe '#create' do
    it 'can create simple Enclosure Group' do
      item_1 = OneviewSDK::EnclosureGroup.new($client, enclosure_group_options)
      item_1.create
      expect(item_1['name']).to eq(ENC_GROUP_NAME)
    end

    it 'can create EnclosureGroup with LIG' do
      item_2 = OneviewSDK::EnclosureGroup.new($client, enclosure_group_options_2)
      lig = OneviewSDK::LogicalInterconnectGroup.new($client, 'name' => LOG_INT_GROUP_NAME)
      lig.retrieve!
      item_2.add_logical_interconnect_group(lig)
      item_2.create
      expect(item_2['name']).to eq(ENC_GROUP2_NAME)
      item_2['interconnectBayMappings'].each do |bay|
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 1
        expect(bay['logicalInterconnectGroupUri']).to_not be if bay['interconnectBay'] != 1
      end
    end

    it 'can create EnclosureGroup with empty LIG' do
      item_3 = OneviewSDK::EnclosureGroup.new($client, enclosure_group_options_3)
      lig = OneviewSDK::LogicalInterconnectGroup.new($client, 'name' => LOG_INT_GROUP3_NAME)
      lig.retrieve!
      item_3.add_logical_interconnect_group(lig)
      item_3.create
      expect(item_3['name']).to eq(ENC_GROUP3_NAME)
      item_3['interconnectBayMappings'].each do |bay|
        expect(bay['logicalInterconnectGroupUri']).to_not be
      end
    end
  end
end
