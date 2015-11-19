require 'spec_helper'
require 'json'

RSpec.describe OneviewSDK::EthernetNetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      file = File.read('spec/support/fixtures/integration/ethernet_network.json')
      configs = JSON.parse(file)
      item = OneviewSDK::EthernetNetwork.new(@client, configs)
      item.create
      expect(item[:name]).to eq('vlan_01')
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:vlanId]).to eq(1001)
      expect(item[:purpose]).to eq('General')
      expect(item[:smartLink]).to eq(false)
      expect(item[:privateNetwork]).to eq(false)
    end
  end

  describe '#retrieve!' do
    it 'Retrieves the resource' do
      item = OneviewSDK::EthernetNetwork.new(@client, name: 'vlan_01')
      item.retrieve!
      expect(item[:name]).to eq('vlan_01')
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:vlanId]).to eq(1001)
      expect(item[:purpose]).to eq('General')
      expect(item[:smartLink]).to eq(false)
      expect(item[:privateNetwork]).to eq(false)
    end
  end

  describe '#update' do
    it 'Update vlan_01 name' do
      item = OneviewSDK::EthernetNetwork.new(@client, name: 'vlan_01')
      item.retrieve!
      item[:name] = 'vlan_02'
      item.update
      item.refresh
      expec(item[:name]).to eq('vlan_02')
    end
  end

  describe '#delete' do
    it 'Deletes the resource' do
      item = OneviewSDK::EthernetNetwork.new(@client, name: 'vlan_02')
      item.retrieve!
      item.delete
    end
  end

  describe '#findBy' do
    names = %w(vlan_01 vlan_02 vlan_03)
    it 'Adding temporary networks' do
      file = File.read('spec/support/fixtures/integration/ethernet_network.json')
      configs = JSON.parse(file)
      names.each do |name|
        item = OneviewSDK::EthernetNetwork.new(@client, configs)
        item[:name] = name
        item.create
      end
      network_list = OneviewSDK::EthernetNetwork.find_by(@client, {}).map { |item| item[:name] }
      expect(names - network_list).to match_array([])
      OneviewSDK::EthernetNetwork.find_by(@client, {}).each { |network| network.delete if names.include?(network[:name]) }
      network_list = OneviewSDK::EthernetNetwork.find_by(@client, {})
      expect(names - network_list).to match(names)
    end
  end

end
