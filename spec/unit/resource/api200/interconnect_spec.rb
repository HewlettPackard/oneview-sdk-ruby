require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect do
  include_context 'shared context'

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::Interconnect.new(@client_200, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#retrieve!' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1' },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2' }
      ])
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI).and_return(resp)
    end

    it 'retrieves by name' do
      expect(described_class.new(@client_200, name: 'name1').retrieve!).to be true
      expect(described_class.new(@client_200, name: 'fake').retrieve!).to be false
    end

    it 'retrieves by uri' do
      expect(described_class.new(@client_200, uri: 'uri1').retrieve!).to be true
      expect(described_class.new(@client_200, uri: 'fake').retrieve!).to be false
    end

    it 'retrieves by serialNumber' do
      expect(described_class.new(@client_200, serialNumber: 'sn1').retrieve!).to be true
      expect(described_class.new(@client_200, serialNumber: 'fake').retrieve!).to be false
    end
  end

  describe '#exists?' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1' },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2' }
      ])
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI).and_return(resp)
    end

    it 'finds it by name' do
      expect(described_class.new(@client_200, name: 'name1').exists?).to be true
      expect(described_class.new(@client_200, name: 'fake').exists?).to be false
    end

    it 'finds it by uri' do
      expect(described_class.new(@client_200, uri: 'uri1').exists?).to be true
      expect(described_class.new(@client_200, uri: 'fake').exists?).to be false
    end

    it 'finds it by serialNumber' do
      expect(described_class.new(@client_200, serialNumber: 'sn1').exists?).to be true
      expect(described_class.new(@client_200, serialNumber: 'fake').exists?).to be false
    end
  end

  describe 'statistics' do
    before :each do
      @item = OneviewSDK::Interconnect.new(@client_200, {})
    end

    it 'port' do
      expect(@client_200).to receive(:rest_get).with('/statistics/p1').and_return(FakeResponse.new)
      @item.statistics('p1')
    end

    it 'port and subport' do
      expect(@client_200).to receive(:rest_get).with('/statistics/p1/subport/sp1').and_return(FakeResponse.new)
      @item.statistics('p1', 'sp1')
    end
  end

  describe '#get_type' do
    it 'finds the specified interconnect_type' do
      interconnect_type_type_list = FakeResponse.new(
        'members' => [
          { 'name' => 'interconnect_typeA', 'uri' => 'rest/fake/A' },
          { 'name' => 'Theinterconnect_type', 'uri' => 'rest/fake/interconnect_type' },
          { 'name' => 'interconnect_typeC', 'uri' => 'rest/fake/C' }
        ]
      )
      expect(@client_200).to receive(:rest_get).with('/rest/interconnect-types').and_return(interconnect_type_type_list)
      @item = OneviewSDK::Interconnect.get_type(@client_200, 'Theinterconnect_type')
      expect(@item['uri']).to eq('rest/fake/interconnect_type')
    end
  end

  describe '#name_servers' do
    it 'should get the name servers' do
      item = OneviewSDK::Interconnect.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_get).with('/rest/fake/nameServers').and_return(FakeResponse.new)
      expect(item.name_servers).to be
    end
  end

  describe '#patch' do
    it 'sends a patch request to the interconnect' do
      item = OneviewSDK::Interconnect.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_patch)
        .with(item['uri'], 'body' => [{ op: 'replace', path: '/uidState', value: 'On' }])
        .and_return(FakeResponse.new)
      expect(item.patch('replace', '/uidState', 'On')).to be
    end
  end

  describe '#reset_port_protection' do
    it 'sets the port protection' do
      item = OneviewSDK::Interconnect.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_put).with('/rest/fake/resetportprotection').and_return(FakeResponse.new)
      expect(item.reset_port_protection).to be
    end
  end

  describe '#update_port' do
    it 'updates an interconnect port' do
      options = {
        'uri' => '/rest/fake',
        'ports' => [
          {
            'name' => 'port1',
            'enabled' => true
          }
        ]
      }

      options_2 = {
        'name' => 'port1',
        'enabled' => false
      }

      item = OneviewSDK::Interconnect.new(@client_200, options)
      expect(@client_200).to receive(:rest_put).with('/rest/fake/ports', 'body' => options_2).and_return(true)
      expect(@client_200).to receive(:response_handler).with(true).and_return(FakeResponse.new)
      expect(item.update_port('port1', enabled: false)).to be
    end
  end
end
