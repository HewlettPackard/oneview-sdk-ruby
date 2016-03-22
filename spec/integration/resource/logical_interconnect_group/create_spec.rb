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
  let(:lig) { OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe '#create' do
    before(:each) do
      lig.delete if lig.retrieve!
    end

    it 'simple LIG' do
      expect { lig.create }.not_to raise_error
      expect(lig['uri']).to be
    end

    it 'LIG with unrecognized interconnect' do
      expect { lig.add_interconnect(1, 'invalid_type') }.to raise_error(/Interconnect type invalid_type/)
    end

    it 'LIG with interconnect' do
      lig.add_interconnect(1, interconnect_type)
      expect { lig.create }.not_to raise_error
      expect(lig['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      lig.data = lig_default_options
      expect(lig['name']).to be
      lig.retrieve!
      expect(lig['uri']).to be
    end
  end

  describe 'getters' do
    before(:each) do
      lig.retrieve! unless lig['uri']
    end

    it 'default settings' do
      default_settings = lig.get_default_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to eq('/ethernetSettings')
    end

    it 'current settings' do
      default_settings = lig.get_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq('InterconnectSettingsV3')
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to_not eq('/ethernetSettings')
    end
  end
end
