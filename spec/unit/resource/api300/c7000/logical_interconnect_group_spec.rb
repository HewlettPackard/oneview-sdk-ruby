require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LogicalInterconnectGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::API300::C7000::LogicalInterconnectGroup.new(@client_300)
      expect(item['enclosureType']).to eq('C7000')
      expect(item['state']).to eq('Active')
      expect(item['uplinkSets']).to eq([])
      expect(item['type']).to eq('logical-interconnect-groupV300')
      expect(item['interconnectMapTemplate']).to eq('interconnectMapEntryTemplates' => [])
      expect(item['interconnectMapTemplate']['interconnectMapEntryTemplates']).to be_empty
    end
  end

  describe '#add_interconnect' do
    before :each do
      @item = OneviewSDK::API300::C7000::LogicalInterconnectGroup.new(@client_300)
      @type = 'HP VC FlexFabric-20/40 F8 Module'
    end

    it 'adds a valid interconnect' do
      expect(OneviewSDK::Interconnect).to receive(:get_type).with(@client_300, @type)
        .and_return('uri' => '/rest/fake')
      @item.add_interconnect(3, @type)

      location_entries = @item['interconnectMapTemplate']['interconnectMapEntryTemplates'].first['logicalLocation']['locationEntries']
      expect(location_entries.size).to eq(2)

      bay_entry, enclosure_entry = location_entries
      expect(bay_entry['type']).to eq('Bay')
      expect(bay_entry['relativeValue']).to eq(3)
      expect(enclosure_entry['type']).to eq('Enclosure')
      expect(enclosure_entry['relativeValue']).to eq(1)

      permitted_interconnect_type_uri = @item['interconnectMapTemplate']['interconnectMapEntryTemplates'].first['permittedInterconnectTypeUri']
      expect(permitted_interconnect_type_uri).to eq('/rest/fake')
    end

    it 'raises an error if the interconnect is not found' do
      expect(OneviewSDK::Interconnect).to receive(:get_type).with(@client_300, @type)
        .and_return(nil)
      expect(OneviewSDK::Interconnect).to receive(:get_types).and_return([{ 'name' => '1' }, { 'name' => '2' }])
      expect { @item.add_interconnect(3, @type) }.to raise_error(/not found!/)
    end
  end

  describe '#add_uplink_set' do
    it 'adds it to the \'uplinkSets\' data attribute' do
      item = OneviewSDK::API300::C7000::LogicalInterconnectGroup.new(@client_300)
      uplink = OneviewSDK::API300::C7000::UplinkSet.new(@client_300)
      item.add_uplink_set(uplink)
      expect(item['uplinkSets'].size).to eq(1)
      expect(item['uplinkSets'].first).to eq(uplink.data)
    end
  end

  describe '::get_default_settings' do
    it 'should get the default settings' do
      expect(@client_300).to receive(:rest_get).with('/rest/logical-interconnect-groups/defaultSettings', @client_300.api_version)
        .and_return(FakeResponse.new)
      expect(OneviewSDK::LogicalInterconnectGroup.get_default_settings(@client_300)).to be
    end
  end
end
