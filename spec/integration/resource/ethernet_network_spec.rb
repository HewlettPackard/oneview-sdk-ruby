require 'spec_helper'

RSpec.describe OneviewSDK::EthernetNetwork, integration: true do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/ethernet_network.json' }
  let(:resource_name) { 'EthernetNetwork_1' }
  let(:updated_resource_name) { 'EthernetNetwork_1_UPDATED' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::EthernetNetwork.from_file(@client, file_path)
      item.create
      expect(item[:name]).to eq(resource_name)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:vlanId]).to eq(1001)
      expect(item[:purpose]).to eq('General')
      expect(item[:smartLink]).to eq(false)
      expect(item[:privateNetwork]).to eq(false)
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::EthernetNetwork.new(@client, name: resource_name)
      item.retrieve!
      expect(item[:name]).to eq(resource_name)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:vlanId]).to eq(1001)
      expect(item[:purpose]).to eq('General')
      expect(item[:smartLink]).to eq(false)
      expect(item[:privateNetwork]).to eq(false)
    end
  end

  # describe '#update' do
  #   it 'update OneViewSDK_Int_Ethernet_Network name' do
  #     item = OneviewSDK::EthernetNetwork.new(@client, name: resource_name)
  #     item.retrieve!
  #     item.update(name: updated_resource_name)
  #     item.refresh
  #     expect(item[:name]).to eq(updated_resource_name)
  #   end
  # end
  #
  # describe '#find_by' do
  #   it 'returns all resources when the hash is empty' do
  #     names = OneviewSDK::EthernetNetwork.find_by(@client, {}).map { |item| item[:name] }
  #     expect(names).to include(updated_resource_name)
  #   end
  #
  #   it 'finds networks by multiple attributes' do
  #     attrs = { name: updated_resource_name, vlanId: 1001, purpose: 'General' }
  #     names = OneviewSDK::EthernetNetwork.find_by(@client, attrs).map { |item| item[:name] }
  #     expect(names).to include(updated_resource_name)
  #   end
  # end
  #
  # describe '#delete' do
  #   it 'deletes the resource' do
  #     item = OneviewSDK::EthernetNetwork.new(@client, name: updated_resource_name)
  #     item.retrieve!
  #     item.delete
  #   end
  # end

end
