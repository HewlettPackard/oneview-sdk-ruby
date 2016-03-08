require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork, integration: true do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/fcoe_network.json' }
  let(:resource_name) { 'FCoENetwork_01' }
  let(:updated_resource_name) { 'FCoENetwork_01_UPDATED' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::FCoENetwork.from_file(@client, file_path)
      item.create
      expect(item[:name]).to eq(resource_name)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:vlanId]).to eq(300)
      expect(item[:type]).to eq('fcoe-network')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::FCoENetwork.new(@client, name: resource_name)
      item.retrieve!
      expect(item[:name]).to eq(resource_name)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:vlanId]).to eq(300)
      expect(item[:type]).to eq('fcoe-network')
    end
  end

  describe '#update' do
    it 'update OneViewSDK Test FCoE Network name' do
      item = OneviewSDK::FCoENetwork.new(@client, name: resource_name)
      item.retrieve!
      item.update(name: updated_resource_name)
      item.refresh
      expect(item[:name]).to eq(updated_resource_name)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::FCoENetwork.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include(updated_resource_name)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: updated_resource_name, vlanId: 300, type: 'fcoe-network' }
      names = OneviewSDK::FCoENetwork.find_by(@client, attrs).map { |item| item[:name] }
      expect(names).to include(updated_resource_name)
    end
  end

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::FCoENetwork.new(@client, name: updated_resource_name)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end

end
