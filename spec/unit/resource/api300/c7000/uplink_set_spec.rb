require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::UplinkSet do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::UplinkSet
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      profile = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
      expect(profile[:type]).to eq('uplink-setV300')
      expect(profile[:portConfigInfos]).to eq([])
      expect(profile[:networkUris]).to eq([])
      expect(profile[:fcNetworkUris]).to eq([])
      expect(profile[:fcoeNetworkUris]).to eq([])
      expect(profile[:primaryPortLocation]).to eq(nil)
    end
  end

  describe '#add_port_config' do
    it 'updates the portConfigInfos value' do
      item = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
      item.add_port_config('/rest/fake', 1000, [{ 'value' => '1', 'type' => 'Bay' }, { 'value' => '/rest/fake2', 'type' => 'Enclosure' }])
      expect(item['portConfigInfos'].size).to eq(1)
      expect(item['portConfigInfos'].first['portUri']).to eq('/rest/fake')
      expect(item['portConfigInfos'].first['desiredSpeed']).to eq(1000)
      expect(item['portConfigInfos'].first['location']['locationEntries'].size).to eq(2)
    end
  end

  describe 'add elements' do
    context 'networks' do
      it 'Valid' do
        uplink = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
        uplink.add_network(uri: '/rest/ethernet-networks')
        uplink.add_fcnetwork(uri: '/rest/fc-networks')
        uplink.add_fcoenetwork(uri: '/rest/fcoe-networks')
        expect(uplink[:networkUris]).to include('/rest/ethernet-networks')
        expect(uplink[:fcNetworkUris]).to include('/rest/fc-networks')
        expect(uplink[:fcoeNetworkUris]).to include('/rest/fcoe-networks')
      end

      it 'Incorrect' do
        uplink = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
        expect { uplink.add_network({}) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
        expect { uplink.add_fcnetwork({}) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
        expect { uplink.add_fcoenetwork({}) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
      end
    end

    context 'logical interconnects' do
      it 'Valid' do
        uplink = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
        uplink.set_logical_interconnect(uri: '/rest/logical-interconnects')
        expect(uplink[:logicalInterconnectUri]).to eq('/rest/logical-interconnects')
      end

      it 'Incorrect' do
        uplink = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
        expect { uplink.set_logical_interconnect({}) }.to raise_error(OneviewSDK::IncompleteResource, /Invalid object/)
      end
    end
  end

end
