require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect do
  include_context 'shared context'

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::Interconnect.new(@client, {})
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

  # name uri serialNumber interconnectIP
  describe '#retrieve!' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', interconnectIP: 'ip1' },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', interconnectIP: 'ip2' }
      ])
      allow(@client).to receive(:rest_get).with(described_class::BASE_URI).and_return(resp)
    end

    it 'retrieves by name' do
      expect(described_class.new(@client, name: 'name1').retrieve!).to be true
      expect(described_class.new(@client, name: 'fake').retrieve!).to be false
    end

    it 'retrieves by uri' do
      expect(described_class.new(@client, uri: 'uri1').retrieve!).to be true
      expect(described_class.new(@client, uri: 'fake').retrieve!).to be false
    end

    it 'retrieves by serialNumber' do
      expect(described_class.new(@client, serialNumber: 'sn1').retrieve!).to be true
      expect(described_class.new(@client, serialNumber: 'fake').retrieve!).to be false
    end

    it 'retrieves by interconnectIP' do
      expect(described_class.new(@client, interconnectIP: 'ip1').retrieve!).to be true
      expect(described_class.new(@client, interconnectIP: 'fake').retrieve!).to be false
    end
  end

  describe '#exists?' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', interconnectIP: 'ip1' },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', interconnectIP: 'ip2' }
      ])
      allow(@client).to receive(:rest_get).with(described_class::BASE_URI).and_return(resp)
    end

    it 'finds it by name' do
      expect(described_class.new(@client, name: 'name1').exists?).to be true
      expect(described_class.new(@client, name: 'fake').exists?).to be false
    end

    it 'finds it by uri' do
      expect(described_class.new(@client, uri: 'uri1').exists?).to be true
      expect(described_class.new(@client, uri: 'fake').exists?).to be false
    end

    it 'finds it by serialNumber' do
      expect(described_class.new(@client, serialNumber: 'sn1').exists?).to be true
      expect(described_class.new(@client, serialNumber: 'fake').exists?).to be false
    end

    it 'finds it by interconnectIP' do
      expect(described_class.new(@client, interconnectIP: 'ip1').exists?).to be true
      expect(described_class.new(@client, interconnectIP: 'fake').exists?).to be false
    end
  end

  describe 'statistics' do
    before :each do
      @item = OneviewSDK::Interconnect.new(@client, {})
    end

    it 'port' do
      expect(@client).to receive(:rest_get).with('/statistics/p1').and_return(FakeResponse.new)
      @item.statistics('p1')
    end

    it 'port and subport' do
      expect(@client).to receive(:rest_get).with('/statistics/p1/subport/sp1').and_return(FakeResponse.new)
      @item.statistics('p1', 'sp1')
    end

  end
end
