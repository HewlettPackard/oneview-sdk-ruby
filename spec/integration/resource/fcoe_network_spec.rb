require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork, integration: true do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/fcoe_network.json' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::FCoENetwork.from_file(@client, file_path)
      item.create
      expect(item[:name]).to eq('OneViewSDK Test FCoE Network')
      expect(item[:connectionTemplateUri]).to eq(nil)
      expect(item[:vlanId]).to eq(300)
      expect(item[:type]).to eq('fcoe-network')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::FCoENetwork.new(@client, name: 'OneViewSDK Test FCoE Network')
      item.retrieve!
      expect(item[:name]).to eq('OneViewSDK Test FCoE Network')
      expect(item[:connectionTemplateUri]).to eq(nil)
      expect(item[:vlanId]).to eq(300)
      expect(item[:type]).to eq('fcoe-network')
    end
  end

  describe '#update' do
    it 'update OneViewSDK Test FCoE Network name' do
      item = OneviewSDK::FCoENetwork.new(@client, name: 'OneViewSDK Test FCoE Network')
      item.retrieve!
      item.update(name: 'OneViewSDK Test F Net')
      item.refresh
      expect(item[:name]).to eq('OneViewSDK Test F Net')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::FCoENetwork.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include('OneViewSDK Test F Net')
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: 'OneViewSDK Test F Net', vlanId: 300, type: 'fcoe-network' }
      names = OneviewSDK::FCoENetwork.find_by(@client, attrs).map { |item| item[:name] }
      expect(names).to include('OneViewSDK Test F Net')
    end
  end

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::FCoENetwork.new(@client, name: 'OneViewSDK Test F Net')
      item.retrieve!
      item.delete
    end
  end

end
