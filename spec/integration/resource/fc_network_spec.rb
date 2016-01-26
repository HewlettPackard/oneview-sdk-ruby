require 'spec_helper'

RSpec.describe OneviewSDK::FCNetwork, integration: true do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/fc_network.json' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::FCNetwork.from_file(@client, file_path)
      item.create
      expect(item[:name]).to eq('OneViewSDK Test FC Network')
      expect(item[:autoLoginRedistribution]).to eq(true)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::FCNetwork.new(@client, name: 'OneViewSDK Test FC Network')
      item.retrieve!
      expect(item[:name]).to eq('OneViewSDK Test FC Network')
      expect(item[:autoLoginRedistribution]).to eq(true)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end

  describe '#update' do
    it 'update OneViewSDK Test FC Network name' do
      item = OneviewSDK::FCNetwork.new(@client, name: 'OneViewSDK Test FC Network')
      item.retrieve!
      item.update(name: 'OneViewSDK Test F Net')
      item.refresh
      expect(item[:name]).to eq('OneViewSDK Test F Net')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::FCNetwork.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include('OneViewSDK Test F Net')
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: 'OneViewSDK Test F Net', fabricType: 'FabricAttach' }
      names = OneviewSDK::FCNetwork.find_by(@client, attrs).map { |item| item[:name] }
      expect(names).to include('OneViewSDK Test F Net')
    end
  end

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::FCNetwork.new(@client, name: 'OneViewSDK Test F Net')
      item.retrieve!
      item.delete
    end
  end

end
