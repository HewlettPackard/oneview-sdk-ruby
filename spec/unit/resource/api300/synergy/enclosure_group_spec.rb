require 'spec_helper'

klass = OneviewSDK::API300::Synergy::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::EnclosureGroup
  end

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        item = klass.new(@client_300)
        expect(item[:type]).to eq('EnclosureGroupV300')
        expect(item[:stackingMode]).to eq('Enclosure')
        expect(item[:ipAddressingMode]).to eq('DHCP')
        expect(item[:enclosureCount]).to eq(1)
        expect(item[:interconnectBayMappingCount]).to eq(6)
      end
    end
  end

  describe '#script' do
    it 'requires a uri' do
      expect { klass.new(@client_300).get_script }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/script' do
      item = klass.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/script', {}, item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client_300.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.get_script).to eq('Blah')
    end
  end

  describe '#set_script' do
    it 'returns method unavailable for the set_script method' do
      item = klass.new(@client_300, uri: '/rest/fake')
      expect { item.set_script }.to raise_error(/The method #set_script is unavailable for this resource/)
    end
  end

  describe '#create_interconnect_bay_mapping' do
    it 'creates entries for each bay in each enclosure' do
      item = klass.new(@client_300, name: 'EG', enclosureCount: 3)
      expect(item['interconnectBayMappings'].size).to eq(18)
      expect(item['interconnectBayMappings'].first['enclosureIndex']).to eq(1)
      expect(item['interconnectBayMappings'].first['interconnectBay']).to eq(1)
    end
  end
end
