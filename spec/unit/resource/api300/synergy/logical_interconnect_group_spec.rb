require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from the base API300::Resource class, not API200::LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Resource
    expect(described_class).not_to be < OneviewSDK::API200::LogicalInterconnectGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = described_class.new(@client_300)
      expect(item['enclosureType']).to eq('SY12000')
      expect(item['state']).to eq('Active')
      expect(item['uplinkSets']).to eq([])
      expect(item['type']).to eq('logical-interconnect-groupV300')
      expect(item['interconnectMapTemplate']).to eq('interconnectMapEntryTemplates' => [])
      expect(item['interconnectMapTemplate']['interconnectMapEntryTemplates']).to be_empty
      expect(item['redundancyType']).to eq('Redundant')
    end
  end

  describe '#add_uplink_set' do
    it 'adds it to the \'uplinkSets\' data attribute' do
      item = described_class.new(@client_300)
      uplink = OneviewSDK::API300::Synergy::UplinkSet.new(@client_300)
      item.add_uplink_set(uplink)
      expect(item['uplinkSets'].size).to eq(1)
      expect(item['uplinkSets'].first).to eq(uplink.data)
    end
  end

  describe '::get_default_settings' do
    it 'gets the default settings' do
      expect(@client_300).to receive(:rest_get).with('/rest/logical-interconnect-groups/defaultSettings')
                                               .and_return(FakeResponse.new('Default' => 'Settings'))
      expect(described_class.get_default_settings(@client_300)).to eq('Default' => 'Settings')
    end
  end

  describe '#get_settings' do
    it 'gets the current settings' do
      item = described_class.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/settings', {}, 300)
                                               .and_return(FakeResponse.new('Current' => 'Settings'))
      expect(item.get_settings).to eq('Current' => 'Settings')
    end
  end

  describe '#add_internal_network' do
    it 'adds a network' do
      item = described_class.new(@client_300)
      network = OneviewSDK::API300::Synergy::EthernetNetwork.new(@client_200, uri: '/rest/fake')
      expect(item.add_internal_network(network)).to be
      expect(item['internalNetworkUris']).to eq(['/rest/fake'])
    end
  end

  describe '#add_interconnect' do
    before :each do
      @item = described_class.new(@client_300)
      @type = 'Virtual Connect SE 40Gb F8 Module for Synergy'
      @type2 = 'Virtual Connect SE 16Gb FC Module for Synergy'
      @interconnect = { 'uri' => '/rest/fake' }
    end
    it 'adds a valid interconnect type' do
      logical_downlink = OneviewSDK::API300::Synergy::LogicalDownlink.new(@client_300, name: 'LD', uri: '/rest/fake')
      allow(OneviewSDK::API300::Synergy::LogicalDownlink).to receive(:find_by).with(anything, name: 'LD')
                                                                              .and_return([logical_downlink])
      allow(OneviewSDK::API300::Synergy::Interconnect).to receive(:get_type).with(anything, @type)
                                                                            .and_return(@interconnect)
      @item.add_interconnect(1, @type, 'LD')
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['permittedInterconnectTypeUri'])
        .to eq('/rest/fake')
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['logicalDownlinkUri'])
        .to eq('/rest/fake')
    end

    it 'accepts a LogicalDownlink resource as a parameter' do
      logical_downlink = OneviewSDK::API300::Synergy::LogicalDownlink.new(@client_300, name: 'LD', uri: '/rest/fake')
      allow(OneviewSDK::API300::Synergy::Interconnect).to receive(:get_type).and_return(@interconnect)
      @item.add_interconnect(1, @type, logical_downlink)
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['permittedInterconnectTypeUri'])
        .to eq('/rest/fake')
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['logicalDownlinkUri'])
        .to eq('/rest/fake')
    end

    it 'only adds an interconnect if it is not already added' do
      allow(OneviewSDK::API300::Synergy::Interconnect).to receive(:get_type).and_return(@interconnect)
      @item.add_interconnect(1, @type)
      @item.add_interconnect(1, @type)
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'].size).to eq(1)
    end

    it 'adds interconnects with the same bay but different enclosureIndex' do
      allow(OneviewSDK::API300::Synergy::Interconnect).to receive(:get_type).and_return(@interconnect)
      @item.add_interconnect(1, @type, nil, 1)
      @item.add_interconnect(1, @type, nil, -1)
      expect(@item['interconnectMapTemplate']['interconnectMapEntryTemplates'].size).to eq(2)
    end

    it 'sets the correct default enclosureIndex for interconnect types' do
      allow(OneviewSDK::API300::Synergy::Interconnect).to receive(:get_type).twice.and_return(@interconnect)
      @item.add_interconnect(1, @type)
      @item.add_interconnect(1, @type2)
      templates = @item['interconnectMapTemplate']['interconnectMapEntryTemplates']
      expect(templates.size).to eq(2)
      expect(templates[0]['enclosureIndex']).to eq(1)
      expect(templates[1]['enclosureIndex']).to eq(-1)
    end
  end
end
