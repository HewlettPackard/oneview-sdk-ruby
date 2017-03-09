require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = described_class.new(@client_200)
      expect(item['enclosureType']).to eq('C7000')
      expect(item['state']).to eq('Active')
      expect(item['uplinkSets']).to eq([])
      expect(item['type']).to eq('logical-interconnect-groupV3')
      path = 'spec/support/fixtures/unit/resource/lig_default_templates.json'
      expect(item['interconnectMapTemplate']).to eq(JSON.parse(File.read(path)))
      expect(item['interconnectMapTemplate']['interconnectMapEntryTemplates'].size).to eq(8)
    end
  end

  describe '::get_default_settings' do
    it 'should get the default settings' do
      expect(@client_200).to receive(:rest_get).with('/rest/logical-interconnect-groups/defaultSettings', @client_200.api_version)
        .and_return(FakeResponse.new)
      expect(OneviewSDK::LogicalInterconnectGroup.get_default_settings(@client_200)).to be
    end
  end

  describe '#add_interconnect' do
    before :each do
      @item = described_class.new(@client_200)
      @type = 'HP VC FlexFabric-20/40 F8 Module'
    end

    it 'adds a valid interconnect' do
      expect(OneviewSDK::Interconnect).to receive(:get_type).with(@client_200, @type)
        .and_return('uri' => '/rest/fake')
      @item.add_interconnect(3, @type)
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'][2]['permittedInterconnectTypeUri'])
        .to eq('/rest/fake')
    end

    it 'raises an error if the interconnect is not found' do
      expect(OneviewSDK::Interconnect).to receive(:get_type).with(@client_200, @type)
        .and_return([])
      expect(OneviewSDK::Interconnect).to receive(:get_types).and_return([{ 'name' => '1' }, { 'name' => '2' }])
      expect { @item.add_interconnect(3, @type) }.to raise_error(/not found!/)
    end
  end

  describe '#add_uplink_set' do
    it 'adds it to the \'uplinkSets\' data attribute' do
      item = described_class.new(@client_200)
      uplink = OneviewSDK::UplinkSet.new(@client_200)
      item.add_uplink_set(uplink)
      expect(item['uplinkSets'].size).to eq(1)
      expect(item['uplinkSets'].first).to eq(uplink.data)
    end
  end

  describe '#get_settings' do
    it 'should get the settings' do
      item = described_class.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_get).with('/rest/fake/settings', item.api_version)
        .and_return(FakeResponse.new)
      expect(item.get_settings).to be
    end
  end
end
