require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalInterconnectGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API200 and does not inherit from LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Resource
    expect(klass).not_to be < OneviewSDK::API300::Synergy::LogicalInterconnectGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_300)
      expect(item['enclosureType']).to eq('SY12000')
      expect(item['state']).to eq('Active')
      expect(item['uplinkSets']).to eq([])
      expect(item['type']).to eq('logical-interconnect-groupV300')
      expect(item['interconnectMapTemplate']).to eq('interconnectMapEntryTemplates' => [])
      expect(item['interconnectMapTemplate']['interconnectMapEntryTemplates']).to be_empty
    end
  end

  describe '#add_uplink_set' do
    it 'adds it to the \'uplinkSets\' data attribute' do
      item = klass.new(@client_300)
      uplink = OneviewSDK::API300::Synergy::UplinkSet.new(@client_300)
      item.add_uplink_set(uplink)
      expect(item['uplinkSets'].size).to eq(1)
      expect(item['uplinkSets'].first).to eq(uplink.data)
    end
  end

  describe '#settings' do
    it 'gets the default settings' do
      expect(@client_300).to receive(:rest_get).with('/rest/logical-interconnect-groups/defaultSettings')
        .and_return(FakeResponse.new('Default' => 'Settings'))
      expect(klass.get_default_settings(@client_300)).to eq('Default' => 'Settings')
    end

    it 'gets the current settings' do
      item = klass.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/settings', 300)
        .and_return(FakeResponse.new('Current' => 'Settings'))
      expect(item.get_settings).to eq('Current' => 'Settings')
    end
  end

  describe '#add_internal_network' do
    it 'adds a network' do
      item = klass.new(@client_300)
      network = OneviewSDK::API300::Synergy::EthernetNetwork.new(@client, uri: '/rest/fake')
      expect(item.add_internal_network(network)).to be
      expect(item['internalNetworkUris']).to eq(['/rest/fake'])
    end
  end

  describe '#add_interconnect' do
    it 'adds a valid interconnect type' do
      item = klass.new(@client_300)
      type = 'Virtual Connect SE 40Gb F8 Module for Synergy'
      logical_downlink = OneviewSDK::API300::Synergy::LogicalDownlink.new(@client_300, name: 'LD')
      allow(OneviewSDK::API300::Synergy::LogicalDownlink).to receive(:find_by).with(anything, name: 'LD')
        .and_return([logical_downlink])
      logical_downlink['uri'] = '/rest/fake'
      allow(OneviewSDK::API300::Synergy::Interconnect).to receive(:get_type).with(anything, type)
        .and_return('uri' => '/rest/fake')
      item.add_interconnect(1, type, 'LD')
      expect(item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['permittedInterconnectTypeUri'])
        .to eq('/rest/fake')
      expect(item['interconnectMapTemplate']['interconnectMapEntryTemplates'][0]['logicalDownlinkUri'])
        .to eq('/rest/fake')
    end
  end
end
