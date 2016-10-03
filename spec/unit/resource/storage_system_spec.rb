require 'spec_helper'

RSpec.describe OneviewSDK::StorageSystem do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::StorageSystem.new(@client)
      expect(item[:type]).to eq('StorageSystemV3')
    end
  end

  describe '#add' do
    it 'sends just the credentials hash, then the rest of the data' do
      item = OneviewSDK::StorageSystem.new(@client, name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' })
      expect(@client).to receive(:rest_post).with('/rest/storage-systems', { 'body' => item['credentials'] }, item.api_version)
        .and_return(FakeResponse.new('uri' => '/rest/task/fake'))
      allow(@client).to receive(:wait_for).and_return(FakeResponse.new(nil, 200, 'associatedResource' => { 'resourceUri' => '/rest/fake' }))
      expect(item).to receive(:refresh).and_return(true)
      expect(item).to receive(:update).with('name' => 'Fake', 'type' => 'StorageSystemV3').and_return(true)
      item.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      storage = OneviewSDK::StorageSystem.new(@client, uri: '/rest/storage-systems/100')
      expect(@client).to receive(:rest_delete).with('/rest/storage-systems/100', {}, 200).and_return(FakeResponse.new({}))
      storage.remove
    end
  end

  describe '#retrieve!' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', wwn: 'wwn1', credentials: { ip_hostname: 'ip1' } },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', wwn: 'wwn2', credentials: { ip_hostname: 'ip2' } }
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

    it 'retrieves by wwn' do
      expect(described_class.new(@client, wwn: 'wwn1').retrieve!).to be true
      expect(described_class.new(@client, wwn: 'fake').retrieve!).to be false
    end

    it 'retrieves by credentials' do
      expect(described_class.new(@client, credentials: { ip_hostname: 'ip1' }).retrieve!).to be true
      expect(described_class.new(@client, credentials: { ip_hostname: 'fake' }).retrieve!).to be false
    end

    it 'raises an exception if no identifiers are given' do
      item = OneviewSDK::StorageSystem.new(@client, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#exists?' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', wwn: 'wwn1', credentials: { ip_hostname: 'ip1' } },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', wwn: 'wwn2', credentials: { ip_hostname: 'ip2' } }
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

    it 'finds it by wwn' do
      expect(described_class.new(@client, wwn: 'wwn1').exists?).to be true
      expect(described_class.new(@client, wwn: 'fake').exists?).to be false
    end

    it 'finds it by credentials' do
      expect(described_class.new(@client, credentials: { ip_hostname: 'ip1' }).exists?).to be true
      expect(described_class.new(@client, credentials: { ip_hostname: 'fake' }).exists?).to be false
    end

    it 'raises an exception if no identifiers are given' do
      item = OneviewSDK::StorageSystem.new(@client, {})
      expect { item.exists? }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#get_managed_ports' do
    it 'No port given' do
      item = OneviewSDK::StorageSystem.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/managedPorts').and_return(FakeResponse.new({}))
      item.get_managed_ports
    end
    it 'With port given' do
      item = OneviewSDK::StorageSystem.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with('/rest/fake/managedPorts/100').and_return(FakeResponse.new({}))
      item.get_managed_ports(100)
    end
  end

  describe 'undefined methods' do
    it 'does not allow the create action' do
      storage = OneviewSDK::StorageSystem.new(@client)
      expect { storage.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      storage = OneviewSDK::StorageSystem.new(@client)
      expect { storage.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
