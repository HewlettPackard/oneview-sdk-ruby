require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup, integration: true do
  include_context 'integration context'

  let(:enclosure_group) do
    {
      name: 'OneViewSDK Test Enclosure Group',
      stackingMode: 'Enclosure',
      interconnectBayMappingCount: 8,
      interconnectBayMappings: [
        {
          interconnectBay: 1,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 2,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 3,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 4,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 5,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 6,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 7,
          logicalInterconnectGroupUri: nil
        },
        {
          interconnectBay: 8,
          logicalInterconnectGroupUri: nil
        }
      ],
      type: 'EnclosureGroupV200'
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::EnclosureGroup.new(@client, enclosure_group)
      item.create
      expect(item[:name]).to eq('OneViewSDK Test Enclosure Group')
    end
  end

  describe '#script' do
    it 'Retrieve script' do
      item = OneviewSDK::EnclosureGroup.find_by(@client, {}).first
      item.script
    end
    it 'Change script' do
      item = OneviewSDK::EnclosureGroup.find_by(@client, {}).first
      old_script = item.script.tr("\"", '')
      item.script('#TEST COMMAND')
      expect(item.script.tr("\"", '')).to eq('#TEST COMMAND')
      item.script(old_script)
      expect(item.script.tr("\"", '')).to eq(old_script)
    end
  end

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::EnclosureGroup.new(@client, name: 'OneViewSDK Test Enclosure Group')
      item.retrieve!
      item.delete
    end
  end

end
