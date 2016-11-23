require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::EnclosureGroup
extra_klass_1 = OneviewSDK::API300::Thunderbird::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:enclosure_group_options) do
    {
      'name' => ENC_GROUP_NAME,
      'stackingMode' => 'Enclosure',
      'type' => 'EnclosureGroupV300'
    }
  end
  let(:enclosure_group_options_2) do
    {
      'name' => ENC_GROUP2_NAME,
      'stackingMode' => 'Enclosure',
      'type' => 'EnclosureGroupV300',
      'enclosureCount' => 3,
      'interconnectBayMappings' =>
      [
        {
          'enclosureIndex' => 1,
          'interconnectBay' => 2,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 1,
          'interconnectBay' => 5,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 3,
          'interconnectBay' => 2,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 3,
          'interconnectBay' => 5,
          'logicalInterconnectGroupUri' => ''
        }
      ]
    }
  end
  let(:enclosure_group_options_3) do
    {
      'name' => ENC_GROUP3_NAME,
      'stackingMode' => 'Enclosure',
      'type' => 'EnclosureGroupV300'
    }
  end

  describe '#create' do
    it 'can create simple Enclosure Group' do
      item_1 = klass.new($client_300_thunderbird, enclosure_group_options)
      item_1.create
      expect(item_1['name']).to eq(ENC_GROUP_NAME)
    end

    it 'can create EnclosureGroup with LIG' do
      item_2 = klass.new($client_300_thunderbird, enclosure_group_options_2)
      lig = extra_klass_1.new($client_300_thunderbird, 'name' => LOG_INT_GROUP_NAME)
      lig.retrieve!
      enclosure_group_options_2['interconnectBayMappings'].each do |bay|
        bay['logicalInterconnectGroupUri'] = lig['uri']
      end

      item_2.create
      expect(item_2['name']).to eq(ENC_GROUP2_NAME)
      item_2['interconnectBayMappings'].each do |bay|
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 2
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 5
        expect(bay['logicalInterconnectGroupUri']).to_not be if (bay['interconnectBay'] != 2) && (bay['interconnectBay'] != 5)
      end
    end

    it 'can create EnclosureGroup with empty LIG' do
      item_3 = klass.new($client_300_thunderbird, enclosure_group_options_3)
      lig = extra_klass_1.new($client_300_thunderbird, 'name' => LOG_INT_GROUP3_NAME)
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
