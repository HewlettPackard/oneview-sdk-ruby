# Requirements:
# => Ethernet Network 'EthernetNetwork_1'
# => Interconnect Type 'Virtual Connect SE 40Gb F8 Module for Synergy'

require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:interconnect_type) { 'Virtual Connect SE 40Gb F8 Module for Synergy' }

  describe '#create' do
    it 'creates a LIG with interconnect types' do
      lig_default_options = {
        'name' => LOG_INT_GROUP_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 3
      }
      @item = klass.new($client_300, lig_default_options)
      @item.add_interconnect(3, interconnect_type)
      @item.add_interconnect(6, interconnect_type)
      expect { @item.create }.not_to raise_error
    end

    it 'creates an uplink set and a LIG with internal networks' do
      @ethernet_network = OneviewSDK::API300::Thunderbird::EthernetNetwork.new($client_300, name: ETH_NET_NAME)
      @ethernet_network.retrieve!

      lig_default_options = {
        'name' => LOG_INT_GROUP2_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 3
      }
      @item2 = klass.new($client_300, lig_default_options)
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
        'interconnectBaySet' => 3
      }
      @item = klass.new($client_300, lig_default_options)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end

  describe 'getters' do
    before(:all) do
      @item = klass.find_by($client_300, name: LOG_INT_GROUP_NAME).first
    end

    it 'gets the default settings' do
      expect { @item.get_default_settings }.not_to raise_error
    end

    it 'gets the current settings' do
      expect { @item.get_settings }.not_to raise_error
    end
  end
end
