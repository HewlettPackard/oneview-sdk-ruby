require 'spec_helper'

RSpec.describe OneviewSDK::NetworkSet do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 200' do
      item = OneviewSDK::NetworkSet.new(@client_200, {}, 200)
      expect(item['connectionTemplateUri']).to eq(nil)
      expect(item['nativeNetworkUri']).to eq(nil)
      expect(item['networkUris']).to eq([])
      expect(item['type']).to eq('network-set')
    end
  end

  describe '#set_native_network' do
    it 'sets native network for network set' do
      eth1 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth1')
      item = OneviewSDK::NetworkSet.new(@client_200, {}, 200)
      item.set_native_network(eth1)
      expect(item['nativeNetworkUri']).to eq(eth1['uri'])
    end
  end

  describe '#add_ethernet_network' do
    it 'add ethernet network to network set' do
      eth1 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth1')
      item = OneviewSDK::NetworkSet.new(@client_200, {}, 200)
      item.add_ethernet_network(eth1)
      expect(item['networkUris']).to include(eth1['uri'])
    end

    it 'add multiple ethernet networks to network set' do
      eth1 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth1')
      eth2 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth2')
      item = OneviewSDK::NetworkSet.new(@client_200, {}, 200)
      item.add_ethernet_network(eth1)
      item.add_ethernet_network(eth2)
      expect(item['networkUris']).to include(eth1['uri'])
      expect(item['networkUris']).to include(eth2['uri'])
    end
  end

  describe '#remove_ethernet_network' do
    it 'remove ethernet network from network set' do
      eth1 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth1')
      item = OneviewSDK::NetworkSet.new(@client_200, {}, 200)
      item.add_ethernet_network(eth1)
      expect(item['networkUris']).to include(eth1['uri'])
      item.remove_ethernet_network(eth1)
      expect(item['networkUris']).to_not include(eth1['uri'])
    end

    it 'remove multiple ethernet networks from network set' do
      eth1 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth1')
      eth2 = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/eth2')
      item = OneviewSDK::NetworkSet.new(@client_200, {}, 200)
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
      item = OneviewSDK::NetworkSet.new(@client_200, uri: '/rest/network-sets/nset1')
      expect(@client_200).to receive(:rest_get).with('/rest/network-sets/nset1/withoutEthernet').and_return(FakeResponse.new({}))
      item.get_without_ethernet
    end

    it 'class get network set without ethernet' do
      expect(@client_200).to receive(:rest_get).with('/rest/network-sets/withoutEthernet').and_return(FakeResponse.new({}))
      OneviewSDK::NetworkSet.get_without_ethernet(@client_200)
    end
  end
end
