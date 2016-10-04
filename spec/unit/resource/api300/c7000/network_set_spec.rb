require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::NetworkSet do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::NetworkSet
  end

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 200' do
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, {}, 200)
      expect(item['connectionTemplateUri']).to eq(nil)
      expect(item['nativeNetworkUri']).to eq(nil)
      expect(item['networkUris']).to eq([])
      expect(item['type']).to eq('network-set')
    end
  end

  describe '#set_native_network' do
    it 'sets native network for network set' do
      eth1 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth1')
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, {}, 300)
      item.set_native_network(eth1)
      expect(item['nativeNetworkUri']).to eq(eth1['uri'])
    end
  end

  describe '#add_ethernet_network' do
    it 'add ethernet network to network set' do
      eth1 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth1')
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, {}, 300)
      item.add_ethernet_network(eth1)
      expect(item['networkUris']).to include(eth1['uri'])
    end

    it 'add multiple ethernet networks to network set' do
      eth1 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth1')
      eth2 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth2')
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, {}, 300)
      item.add_ethernet_network(eth1)
      item.add_ethernet_network(eth2)
      expect(item['networkUris']).to include(eth1['uri'])
      expect(item['networkUris']).to include(eth2['uri'])
    end
  end

  describe '#remove_ethernet_network' do
    it 'remove ethernet network from network set' do
      eth1 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth1')
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, {}, 300)
      item.add_ethernet_network(eth1)
      expect(item['networkUris']).to include(eth1['uri'])
      item.remove_ethernet_network(eth1)
      expect(item['networkUris']).to_not include(eth1['uri'])
    end

    it 'remove multiple ethernet networks from network set' do
      eth1 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth1')
      eth2 = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/eth2')
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, {}, 300)
      item.add_ethernet_network(eth1)
      item.add_ethernet_network(eth2)
      expect(item['networkUris']).to include(eth1['uri'])
      expect(item['networkUris']).to include(eth2['uri'])

      item.remove_ethernet_network(eth2)
      expect(item['networkUris']).to include(eth1['uri'])
      expect(item['networkUris']).to_not include(eth2['uri'])

      item.remove_ethernet_network(eth1)
      expect(item['networkUris']).to_not include(eth1['uri'])
      expect(item['networkUris']).to_not include(eth2['uri'])
    end
  end

  describe '#get_without_ethernet' do
    it 'instance get network set without ethernet' do
      item = OneviewSDK::API300::C7000::NetworkSet.new(@client_300, uri: '/rest/network-sets/nset1')
      expect(@client_300).to receive(:rest_get).with('/rest/network-sets/nset1/withoutEthernet').and_return(FakeResponse.new({}))
      item.get_without_ethernet
    end

    it 'class get network set without ethernet' do
      expect(@client_300).to receive(:rest_get).with('/rest/network-sets/withoutEthernet').and_return(FakeResponse.new({}))
      OneviewSDK::API300::C7000::NetworkSet.get_without_ethernet(@client_300)
    end
  end
end
