require 'spec_helper'

klass = OneviewSDK::API300::C7000::FCoENetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:file_path) { 'spec/support/fixtures/integration/fcoe_network.json' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::API300::C7000::FCoENetwork.from_file($client_300, file_path)
      item.create
      expect(item[:name]).to eq(FCOE_NET_NAME)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:vlanId]).to eq(300)
      expect(item[:type]).to eq('fcoe-networkV300')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::API300::C7000::FCoENetwork.new($client_300, name: FCOE_NET_NAME)
      item.retrieve!
      expect(item[:name]).to eq(FCOE_NET_NAME)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:vlanId]).to eq(300)
      expect(item[:type]).to eq('fcoe-networkV300')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::API300::C7000::FCoENetwork.find_by($client_300, {}).map { |item| item[:name] }
      expect(names).to include(FCOE_NET_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: FCOE_NET_NAME, vlanId: 300, type: 'fcoe-networkV300' }
      names = OneviewSDK::API300::C7000::FCoENetwork.find_by($client_300, attrs).map { |item| item[:name] }
      expect(names).to include(FCOE_NET_NAME)
    end
  end
end
