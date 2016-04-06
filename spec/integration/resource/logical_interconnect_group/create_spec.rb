require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: CREATE, sequence: 2 do
  include_context 'integration context'

  let(:lig_default_options) do
    {
      'name' => LOG_INT_GROUP_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
  end
  let(:item) { OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe '#create' do
    before(:each) do
      item.delete if item.retrieve!
    end

    it 'simple LIG' do
      expect { item.create }.not_to raise_error
      expect(item['uri']).to be
    end

    it 'LIG with unrecognized interconnect' do
      expect { item.add_interconnect(1, 'invalid_type') }.to raise_error(/Interconnect type invalid_type/)
    end

    it 'LIG with interconnect' do
      item.add_interconnect(1, interconnect_type)
      expect { item.create }.not_to raise_error
      expect(item['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      item.data = lig_default_options
      expect(item['name']).to be
      item.retrieve!
      expect(item['uri']).to be
    end
  end

  describe 'getters' do
    before(:each) do
      item.retrieve! unless item['uri']
    end

    it 'default settings' do
      default_settings = item.get_default_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to eq('/ethernetSettings')
    end

    it 'current settings' do
      default_settings = item.get_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to_not eq('/ethernetSettings')
    end
  end
end
