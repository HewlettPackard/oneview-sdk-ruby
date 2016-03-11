require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true do
  include_context 'integration context'

  let(:resource_name) { 'LogicalInterconnectGroup_1' }
  let(:lig_default_options) do
    {
      'name' => resource_name,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
  end
  let(:lig) { OneviewSDK::LogicalInterconnectGroup.new(@client, lig_default_options) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe '#create' do
    before(:each) do
      lig.delete if lig.retrieve!
    end

    it 'simple LIG' do
      expect { lig.create }.not_to raise_error
      expect(lig['uri']).to be
    end

    it 'LIG with interconnect' do
      lig.add_interconnect(1, interconnect_type)
      expect { lig.create }.not_to raise_error
      expect(lig['uri']).to be
    end

    it 'LIG with unrecognized interconnect' do
      expect { lig.add_interconnect(1, 'invalid_type') }.to raise_error(/Interconnect type invalid_type/)
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      lig.create!
      lig.data = lig_default_options
      expect(lig['name']).to be
      expect { lig.retrieve! }.to_not raise_error
      expect(lig['uri']).to be
    end
  end

  describe 'Get' do
    before(:each) do
      lig.retrieve! unless lig['uri']
    end

    it 'default settings' do
      default_settings = lig.get_default_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to eq('/ethernetSettings')
    end

    it 'current settings' do
      default_settings = lig.get_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to_not eq('/ethernetSettings')
    end
  end

  describe 'Update' do
    it 'adding and removing uplink set' do
      lig.add_interconnect(1, interconnect_type)
      uplink_options = {
        name: 'EthernetUplinkSet_1',
        networkType: 'Ethernet',
        ethernetNetworkType: 'Tagged'
      }
      uplink = OneviewSDK::LIGUplinkSet.new(@client, uplink_options)
      eth = OneviewSDK::EthernetNetwork.new(@client, name: 'EthernetNetwork_1')
      eth.retrieve!
      uplink.add_network(eth)
      uplink.add_uplink(1, 'X1')
      lig.add_uplink_set(uplink)
      expect { lig.create! }.not_to raise_error
      expect(lig['uri']).to be
      expect(lig['uplinkSets']).to_not be_empty

      lig['uplinkSets'] = []
      expect { lig.update }.to_not raise_error
      expect(lig['uri']).to be
      expect(lig['uplinkSets']).to be_empty
    end
  end
end
