require 'spec_helper'

klass = OneviewSDK::API200::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        item = klass.new(@client_200)
        expect(item[:type]).to eq('EnclosureGroupV200')
      end
    end
  end

  describe '#script' do
    it 'requires a uri' do
      expect { klass.new(@client_200).get_script }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/script' do
      item = klass.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_get).with('/rest/fake/script', item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client_200.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.get_script).to eq('Blah')
    end
  end

  describe '#set_script' do
    it 'requires a uri' do
      expect { klass.new(@client_200).set_script('Blah') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/script' do
      item = klass.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_put).with('/rest/fake/script', { 'body' => 'Blah' }, item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client_200.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.set_script('Blah')).to eq(true)
    end
  end

  describe '#create_interconnect_bay_mapping' do
    it 'creates entries for each bay' do
      item = klass.new(@client_200, name: 'EG', enclosureCount: 3)
      expect(item['interconnectBayMappings'].size).to eq(8)
    end
  end

  describe '#add_logical_interconnect_group' do
    before :each do
      @lig = OneviewSDK::API200::LogicalInterconnectGroup.new(@client_200, uri: '/fakelig')
      @lig['interconnectMapTemplate']['interconnectMapEntryTemplates'] = [
        { 'permittedInterconnectTypeUri' => '/fake', 'logicalLocation' => { 'locationEntries' => [{ 'type' => 'Bay', 'relativeValue' => 1 }] } },
        { 'permittedInterconnectTypeUri' => '/fake', 'logicalLocation' => { 'locationEntries' => [{ 'type' => 'Bay', 'relativeValue' => 4 }] } }
      ]
      @item = klass.new(@client_200, name: 'EG', enclosureCount: 3)
    end

    it 'it adds the LIG uri to each applicable bay' do
      @item.add_logical_interconnect_group(@lig)
      bays_with_lig = @item['interconnectBayMappings'].find_all { |i| i['logicalInterconnectGroupUri'] == @lig['uri'] }
      bays = bays_with_lig.map { |i| i['interconnectBay'] }
      expect(bays).to eq([1, 4])
    end

    it 'raises an error if the LIG cannot be retrieved' do
      @lig['uri'] = nil
      expect(@lig).to receive(:retrieve!).and_return false
      expect { @item.add_logical_interconnect_group(@lig) }
        .to raise_error(OneviewSDK::NotFound, /not found/)
    end
  end
end
