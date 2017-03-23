require 'spec_helper'

klass = OneviewSDK::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
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
    @item_2_state_before_create = {} # it is built in #create test and used in #like? test

    lig_default_options_3 = {
      'name' => LOG_INT_GROUP3_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }

    @item_3 = OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options_3)

    lig_default_options_4 = {
      'name' => LOG_INT_GROUP4_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
    @item_4 = OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options_4)

    eth_uplink_options = {
      name: LIG_UPLINK_SET_NAME,
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
    @eth_lig_uplink_set_1 = OneviewSDK::LIGUplinkSet.new($client, eth_uplink_options)
    @eth_lig_uplink_set_2 = OneviewSDK::LIGUplinkSet.new($client, eth_uplink_options)
    @ethernet_network = OneviewSDK::EthernetNetwork.new($client, name: ETH_NET_NAME)
    @ethernet_network.retrieve!

    fc_uplink_options = {
      name: LIG_UPLINK_SET2_NAME,
      networkType: 'FibreChannel'
    }
    @fc_lig_uplink_set = OneviewSDK::LIGUplinkSet.new($client, fc_uplink_options)
    @fc_network = OneviewSDK::FCNetwork.new($client, name: FC_NET_NAME)
    @fc_network.retrieve!
  end

  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }
  let(:interconnect_type2) { 'HP VC FlexFabric-20/40 F8 Module' }

  describe '#create' do
    before(:all) do
      @item.delete if @item.retrieve!
      @item_2.delete if @item_2.retrieve!
      @item_3.delete if @item_3.retrieve!
      @item_4.delete if @item_4.retrieve!
    end

    it 'LIG with unrecognized interconnect' do
      expect { @item.add_interconnect(1, 'invalid_type') }.to raise_error(OneviewSDK::NotFound, /Interconnect type invalid_type not found!/)
    end

    it 'LIG with interconnect of type HP VC FlexFabric-20/40 F8 Module' do
      @item.add_interconnect(1, interconnect_type2)

      @eth_lig_uplink_set_1.add_network(@ethernet_network)
      @eth_lig_uplink_set_1.add_uplink(1, 'X1')
      @eth_lig_uplink_set_1.add_uplink(1, 'X2')
      @item.add_uplink_set(@eth_lig_uplink_set_1)

      expect { @item.create }.not_to raise_error
      expect(@item['uri']).to be
      expect(@item['uplinkSets']).to_not be_empty
    end

    it 'LIG with interconnect and uplink sets' do
      @item_2.add_interconnect(1, interconnect_type)

      # require 'byebug'
      # byebug

      @eth_lig_uplink_set_2.add_network(@ethernet_network)
      @eth_lig_uplink_set_2.add_uplink(1, 'X1')
      @eth_lig_uplink_set_2.add_uplink(1, 'X2')
      @item_2.add_uplink_set(@eth_lig_uplink_set_2)

      @fc_lig_uplink_set.add_network(@fc_network)
      @fc_lig_uplink_set.add_uplink(1, 'X3')
      @fc_lig_uplink_set.add_uplink(1, 'X4')
      @item_2.add_uplink_set(@fc_lig_uplink_set)

      @item_2_state_before_create.merge!(Marshal.load(Marshal.dump(@item_2.data)))

      expect { @item_2.create }.not_to raise_error
      expect(@item_2['uri']).to be
      expect(@item_2['uplinkSets']).to_not be_empty
    end

    it 'LIG with interconnects' do
      @item_3.add_interconnect(1, interconnect_type)
      @item_3.add_interconnect(2, interconnect_type)
      expect { @item_3.create }.not_to raise_error
      expect(@item_3['uri']).to be
      expect(@item_3['uplinkSets']).to be_empty
    end

    it 'Empty LIG' do
      expect { @item_4.create }.not_to raise_error
      expect(@item_4['uri']).to be
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
      default_settings = OneviewSDK::LogicalInterconnectGroup.get_default_settings($client)
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to match(/ethernetSettings/)
    end

    it 'default settings from the lig instance' do
      default_settings = @item.get_default_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to match(/ethernetSettings/)
    end

    it 'current settings' do
      default_settings = @item.get_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to match(/ethernetSettings/)
    end
  end

  describe '#like?' do
    context 'when logical interconnect group has interconnect and uplink sets and use "like?" with identical data' do
      it 'should work properly' do
        lig_item_2 = OneviewSDK::API200::LogicalInterconnectGroup.find_by($client, name: LOG_INT_GROUP2_NAME).first
        expect(lig_item_2.like?(@item_2_state_before_create)).to eq(true)
      end
    end
  end
end
