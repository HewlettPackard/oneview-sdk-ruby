require 'spec_helper'

RSpec.describe OneviewSDK::UplinkSet, integration: true do
  include_context 'integration context'

  let(:uplink_data) do
    {
      nativeNetworkUri: nil,
      reachability: 'Reachable',
      logicalInterconnectUri: '/rest/logical-interconnects/35faa52f-bda1-445e-9f59-fc5f6dd34fce',
      manualLoginRedistributionState: 'NotSupported',
      connectionMode: 'Auto',
      lacpTimer: 'Short',
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged',
      description: nil,
      name: 'Teste Uplink'
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::UplinkSet.new(@client, uplink_data)
      expect { item.create }.not_to raise_error
      expect(item[:uri]).not_to be_empty
    end
  end

  describe '#update' do
    it 'update portConfigInfos' do
      uplink = OneviewSDK::UplinkSet.new(@client, name: 'Teste Uplink')
      expect { uplink.retrieve! }.not_to raise_error
      uplink.add_portConfig(
        '/rest/interconnects/14be5eee-4b3d-4400-b343-f9cf323ce998',
        'Auto',
        [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X7', type: 'Port' }]
      )
      expect { uplink.save }.not_to raise_error
    end
  end

  describe '#delete' do
    it 'delete resource' do
      item = OneviewSDK::UplinkSet.new(@client, name: 'Teste Uplink')
      expect { item.retrieve! }.not_to raise_error
      expect { item.delete }.not_to raise_error
    end
  end

end
