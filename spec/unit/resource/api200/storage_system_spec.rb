require 'spec_helper'

RSpec.describe OneviewSDK::StorageSystem do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::StorageSystem.new(@client_200)
      expect(item[:type]).to eq('StorageSystemV3')
    end
  end

  describe '#add' do
    it 'sends just the credentials hash, then the rest of the data' do
      item = OneviewSDK::StorageSystem.new(@client_200, name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' })
      expect(@client_200).to receive(:rest_post).with('/rest/storage-systems', { 'body' => item['credentials'] }, item.api_version)
                                                .and_return(FakeResponse.new('uri' => '/rest/task/fake'))
      allow(@client_200).to receive(:wait_for).and_return(FakeResponse.new(nil, 200, 'associatedResource' => { 'resourceUri' => '/rest/fake' }))
      expect(item).to receive(:refresh).and_return(true)
      expect(item).to receive(:update).with('name' => 'Fake', 'type' => 'StorageSystemV3').and_return(true)
      item.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      storage = OneviewSDK::StorageSystem.new(@client_200, uri: '/rest/storage-systems/100')
      expect(@client_200).to receive(:rest_delete).with('/rest/storage-systems/100', {}, 200).and_return(FakeResponse.new({}))
      storage.remove
    end
  end

  describe '#retrieve!' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', wwn: 'wwn1', credentials: { ip_hostname: 'ip1' } },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', wwn: 'wwn2', credentials: { ip_hostname: 'ip2' } }
      ])
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI, {}).and_return(resp)
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

    it 'retrieves by wwn' do
      expect(described_class.new(@client_200, wwn: 'wwn1').retrieve!).to be true
      expect(described_class.new(@client_200, wwn: 'fake').retrieve!).to be false
    end

    it 'retrieves by credentials' do
      expect(described_class.new(@client_200, credentials: { ip_hostname: 'ip1' }).retrieve!).to be true
      expect(described_class.new(@client_200, credentials: { ip_hostname: 'fake' }).retrieve!).to be false
    end

    it 'raises an exception if no identifiers are given' do
      item = OneviewSDK::StorageSystem.new(@client_200, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#exists?' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', serialNumber: 'sn1', wwn: 'wwn1', credentials: { ip_hostname: 'ip1' } },
        { name: 'name2', uri: 'uri2', serialNumber: 'sn2', wwn: 'wwn2', credentials: { ip_hostname: 'ip2' } }
      ])
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI, {}).and_return(resp)
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

    it 'finds it by wwn' do
      expect(described_class.new(@client_200, wwn: 'wwn1').exists?).to be true
      expect(described_class.new(@client_200, wwn: 'fake').exists?).to be false
    end

    it 'finds it by credentials' do
      expect(described_class.new(@client_200, credentials: { ip_hostname: 'ip1' }).exists?).to be true
      expect(described_class.new(@client_200, credentials: { ip_hostname: 'fake' }).exists?).to be false
    end

    it 'raises an exception if no identifiers are given' do
      item = OneviewSDK::StorageSystem.new(@client_200, {})
      expect { item.exists? }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#like?' do
    it 'must not compare storage system credentials with password and hash String' do
      options = {
        name: 'StorageSystemName',
        credentials: {
          ip_hostname: '127.0.0.1',
          username: 'user',
          password: 'pass'
        },
        state: 'Configured'
      }
      item = OneviewSDK::StorageSystem.new(
        @client_200,
        name: 'StorageSystemName',
        credentials: {
          'ip_hostname' => '127.0.0.1',
          'username' => 'user'
        },
        state: 'Configured'
      )
      expect(item.like?(options)).to eq(true)
    end

    it 'must not compare storage system credentials with password and key Symbol' do
      options = {
        'name' => 'StorageSystemName',
        'credentials' => {
          'ip_hostname' => '127.0.0.1',
          'username' => 'user',
          'password' => 'pass'
        },
        'state' => 'Configured'
      }
      item = OneviewSDK::StorageSystem.new(
        @client_200,
        'name' => 'StorageSystemName',
        'credentials' => {
          'ip_hostname' => '127.0.0.1',
          'username' => 'user'
        },
        'state' => 'Configured'
      )
      expect(item.like?(options)).to eq(true)
    end

    it 'must not compare storage system credentials with password when compares resources' do
      item1 = OneviewSDK::StorageSystem.new(@client_200, name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin' })
      item2 = OneviewSDK::StorageSystem.new(@client_200, name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' })
      expect(item1.like?(item2)).to eq(true)
    end

    it 'must not compare storage system with invalid data types' do
      item1 = OneviewSDK::StorageSystem.new(@client_200, name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin' })
      expect(item1.like?(credentials: true)).to eq(false)
    end
  end

  describe '#host-types' do
    it 'List Host Types' do
      expect(@client_200).to receive(:rest_get).with('/rest/storage-systems/host-types').and_return(FakeResponse.new({}))
      expect { OneviewSDK::StorageSystem.get_host_types(@client_200) }.not_to raise_error
    end
  end

  describe '#storage pools' do
    it 'List Storage Pools' do
      item = OneviewSDK::StorageSystem.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_get).with('/rest/fake/storage-pools', {}).and_return(FakeResponse.new({}))
      expect { item.get_storage_pools }.not_to raise_error
    end
  end

  describe '#get_managed_ports' do
    it 'No port given' do
      item = OneviewSDK::StorageSystem.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_get).with('/rest/fake/managedPorts', {}).and_return(FakeResponse.new({}))
      item.get_managed_ports
    end
    it 'With port given' do
      item = OneviewSDK::StorageSystem.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_get).with('/rest/fake/managedPorts/100', {}).and_return(FakeResponse.new({}))
      item.get_managed_ports(100)
    end
  end

  describe 'undefined methods' do
    it 'does not allow the create action' do
      storage = OneviewSDK::StorageSystem.new(@client_200)
      expect { storage.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      storage = OneviewSDK::StorageSystem.new(@client_200)
      expect { storage.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#set_refresh_state' do
    it 'Refreshing a storage system' do
      options = {
        uri: '/rest/storage-systems/100',
        refreshState: 'NotRefreshing'
      }
      options_update = {
        uri: '/rest/storage-systems/100',
        refreshState: 'RefreshPending'
      }
      storage = OneviewSDK::StorageSystem.new(@client_200, options)
      storage_updated = OneviewSDK::StorageSystem.new(@client_200, options_update)
      allow_any_instance_of(OneviewSDK::StorageSystem).to receive(:update).and_return(FakeResponse.new(storage_updated))
      expect { storage.set_refresh_state('RefreshPending') }.not_to raise_error
      expect(storage['refreshState']).to eq('RefreshPending')
    end
  end
end
