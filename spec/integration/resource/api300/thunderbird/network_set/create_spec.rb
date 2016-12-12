require 'spec_helper'

klass = OneviewSDK::API300::Synergy::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'network set withoutEthernet' do
      item = OneviewSDK::API300::Synergy::NetworkSet.new($client_300_synergy)
      item['name'] = NETWORK_SET1_NAME
      item.create
      expect(item['uri']).to_not eq(nil)
    end

    it 'network set with ethernet network' do
      eth1 = OneviewSDK::API300::Synergy::EthernetNetwork.find_by($client_300_synergy, {}).first
      item = OneviewSDK::API300::Synergy::NetworkSet.new($client_300_synergy)
      item['name'] = NETWORK_SET2_NAME
      item.add_ethernet_network(eth1)
      item.create
      expect(item['uri']).to_not eq(nil)
      expect(item['networkUris']).to include(eth1['uri'])
    end

    it 'network set with multiple ethernet networks' do
      eth1 = OneviewSDK::API300::Synergy::EthernetNetwork.find_by($client_300_synergy, {}).first
      eth2 = OneviewSDK::API300::Synergy::EthernetNetwork.find_by($client_300_synergy, {}).last
      item = OneviewSDK::API300::Synergy::NetworkSet.new($client_300_synergy)
      item['name'] = NETWORK_SET3_NAME
      item.add_ethernet_network(eth1)
      item.add_ethernet_network(eth2)
      item.create
      expect(item['uri']).to_not eq(nil)
      expect(item['networkUris']).to include(eth1['uri'])
      expect(item['networkUris']).to include(eth2['uri'])
    end

    it 'network set with native network' do
      eth1 = OneviewSDK::API300::Synergy::EthernetNetwork.find_by($client_300_synergy, {}).first
      item = OneviewSDK::API300::Synergy::NetworkSet.new($client_300_synergy)
      item['name'] = NETWORK_SET4_NAME
      item.set_native_network(eth1)
      item.create
      expect(item['uri']).to_not eq(nil)
      expect(item['nativeNetworkUri']).to include(eth1['uri'])
    end

  end

end
