require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup, integration: true do
  include_context 'integration context'

  let(:resource_name) { 'EnclosureGroup_01' }
  let(:resource_name_02) { 'EnclosureGroup_02' }
  let(:enclosure_group_options) do
    {
      'name' => resource_name,
      'stackingMode' => 'Enclosure',
      'interconnectBayMappingCount' => 8,
      'type' => 'EnclosureGroupV200'
    }
  end
  let(:enclosure_group_options_02) do
    {
      'name' => resource_name_02,
      'stackingMode' => 'Enclosure',
      'interconnectBayMappingCount' => 8,
      'type' => 'EnclosureGroupV200'
    }
  end

  describe '#create' do
    it 'can create simple Enclosure Group' do
      item = OneviewSDK::EnclosureGroup.new(@client, enclosure_group_options)
      item.create
      expect(item['name']).to eq(resource_name)
    end

    it 'can create EnclosureGroup with LIG' do
      item = OneviewSDK::EnclosureGroup.new(@client, enclosure_group_options_02)
      lig = OneviewSDK::LogicalInterconnectGroup.new(@client, 'name' => 'LogicalInterconnectGroup_01')
      lig.retrieve!
      item.add_logical_interconnect_group(lig)
      item.create
      expect(item['name']).to eq(resource_name_02)
      item['interconnectBayMappings'].each do |bay|
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 1
        expect(bay['logicalInterconnectGroupUri']).to_not be if bay['interconnectBay'] != 1
      end
    end
  end

  describe '#script' do
    it 'can retrieve the script' do
      item = OneviewSDK::EnclosureGroup.find_by(@client, {}).first
      item.script
    end

    it 'can set the script' do
      item = OneviewSDK::EnclosureGroup.find_by(@client, {}).first
      item.set_script('#TEST COMMAND')
      expect(item.script.tr('"', '')).to eq('#TEST COMMAND')
    end
  end

  # describe '#delete' do
  #   it 'deletes the simple enclosure group' do
  #     item = OneviewSDK::EnclosureGroup.new(@client, 'name' => resource_name)
  #     item.retrieve!
  #     item.delete
  #   end
  #
  #   it 'deletes the enclosure group with LIG' do
  #     item = OneviewSDK::EnclosureGroup.new(@client, 'name' => resource_name_02)
  #     item.retrieve!
  #     item.delete
  #   end
  # end

end
