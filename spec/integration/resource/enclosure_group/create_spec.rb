require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup, integration: true, type: CREATE, sequence: 3 do
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

  describe '#create' do
    it 'can create simple Enclosure Group' do
      item = OneviewSDK::EnclosureGroup.new($client, enclosure_group_options)
      item.create
      expect(item['name']).to eq(ENC_GROUP_NAME)
    end

    it 'can create EnclosureGroup with LIG' do
      item = OneviewSDK::EnclosureGroup.new($client, enclosure_group_options_2)
      lig = OneviewSDK::LogicalInterconnectGroup.new($client, 'name' => LOG_INT_GROUP_NAME)
      lig.retrieve!
      item.add_logical_interconnect_group(lig)
      item.create
      expect(item['name']).to eq(resource_name_2)
      item['interconnectBayMappings'].each do |bay|
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 1
        expect(bay['logicalInterconnectGroupUri']).to_not be if bay['interconnectBay'] != 1
      end
    end
  end
end
