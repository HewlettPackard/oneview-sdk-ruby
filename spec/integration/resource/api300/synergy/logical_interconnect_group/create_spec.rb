# Requirements:
# => Ethernet Network 'EthernetNetwork_1'
# => Interconnect Type 'Virtual Connect SE 40Gb F8 Module for Synergy'

require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:interconnect_type) { 'Virtual Connect SE 40Gb F8 Module for Synergy' }
  let(:interconnect_type2) { 'Virtual Connect SE 16Gb FC Module for Synergy' }

  describe '#create' do
    it 'creates a LIG with interconnect types' do
      lig_default_options = {
        'name' => LOG_INT_GROUP_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 2,
        'enclosureIndexes' => [-1]
      }
      fc_uplink_options = {
        'name' => LIG_UPLINK_SET2_NAME,
        'networkType' => 'FibreChannel'
      }
      @fc_network = OneviewSDK::API300::Synergy::FCNetwork.new($client_300_synergy, name: FC_NET_NAME)
      @fc_network.retrieve!

      @fc_lig_uplink_set = OneviewSDK::API300::Synergy::LIGUplinkSet.new($client_300_synergy, fc_uplink_options)
      @fc_lig_uplink_set.add_network(@fc_network)

      @item = klass.new($client_300_synergy, lig_default_options)
      @item.add_interconnect(2, interconnect_type2)
      @item.add_interconnect(5, interconnect_type2)
      @item.add_uplink_set(@fc_lig_uplink_set)
      @item['interconnectMapTemplate']['interconnectMapEntryTemplates'].each { |i| i['enclosureIndex'] = -1 }

      expect { @item.create }.not_to raise_error
    end

    it 'creates an uplink set and a LIG with internal networks' do
      @ethernet_network = OneviewSDK::API300::Synergy::EthernetNetwork.new($client_300_synergy, name: ETH_NET_NAME)
      @ethernet_network.retrieve!

      lig_default_options = {
        'name' => LOG_INT_GROUP2_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 3
      }
      @item2 = klass.new($client_300_synergy, lig_default_options)
      @item2.add_interconnect(3, interconnect_type)
      @item2.add_interconnect(6, interconnect_type)
      @item2.add_internal_network(@ethernet_network)
      expect { @item2.create }.not_to raise_error
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      lig_default_options = {
        'name' => LOG_INT_GROUP_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 2
      }
      @item = klass.new($client_300_synergy, lig_default_options)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end

  describe 'getters' do
    it 'gets the default settings' do
      expect { klass.get_default_settings($client_300_synergy) }.not_to raise_error
    end

    it 'gets the current settings' do
      item = klass.find_by($client_300_synergy, name: LOG_INT_GROUP_NAME).first
      expect { item.get_settings }.not_to raise_error
    end
  end
end
