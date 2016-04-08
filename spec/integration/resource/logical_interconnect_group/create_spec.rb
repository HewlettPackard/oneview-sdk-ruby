require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: CREATE, sequence: 2 do
  include_context 'integration context'

  before :all do
    lig_default_options = {
      'name' => LOG_INT_GROUP_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
    @item = OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options)

    lig_default_options_2 = {
      'name' => LOG_INT_GROUP2_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
    @item_2 = OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options_2)

    uplink_options = {
      name: LIG_UPLINK_SET_NAME,
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
    @lig_uplink_set = OneviewSDK::LIGUplinkSet.new($client, uplink_options)

    @ethernet_network = OneviewSDK::EthernetNetwork.new($client, name: ETH_NET_NAME)
    @ethernet_network.retrieve!
  end

  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe '#create' do
    context 'some simple types' do
      before(:each) do
        @item.delete if @item.retrieve!
        @item_2.delete if @item_2.retrieve!
      end

      it 'simple LIG' do
        expect { @item.create }.not_to raise_error
        expect(@item['uri']).to be
      end

      it 'LIG with unrecognized interconnect' do
        expect { @item.add_interconnect(1, 'invalid_type') }.to raise_error(/Interconnect type invalid_type/)
      end
    end

    context 'and most useful types' do
      before(:all) do
        @item.delete if @item.retrieve!
        @item_2.delete if @item_2.retrieve!
      end

      it 'LIG with interconnect and uplink set' do
        @lig_uplink_set.add_network(@ethernet_network)
        @lig_uplink_set.add_uplink(1, 'X1')
        @lig_uplink_set.add_uplink(1, 'X2')
        @item.add_interconnect(1, interconnect_type)
        @item.add_uplink_set(@lig_uplink_set)
        expect { @item.create }.not_to raise_error
        expect(@item['uri']).to be
        expect(@item['uplinkSets']).to_not be_empty
      end

      it 'LIG with interconnects' do
        @item_2.add_interconnect(1, interconnect_type)
        @item_2.add_interconnect(2, interconnect_type)
        expect { @item_2.create }.not_to raise_error
        expect(@item_2['uri']).to be
        expect(@item_2['uplinkSets']).to be_empty
      end
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      lig_default_options = {
        'name' => LOG_INT_GROUP_NAME,
        'enclosureType' => 'C7000',
        'type' => 'logical-interconnect-groupV3'
      }
      @item = OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end

  describe 'getters' do
    before(:each) do
      @item.retrieve! unless @item['uri']
    end

    it 'default settings' do
      default_settings = @item.get_default_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to eq('/ethernetSettings')
    end

    it 'current settings' do
      default_settings = @item.get_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to_not eq('/ethernetSettings')
    end
  end
end
