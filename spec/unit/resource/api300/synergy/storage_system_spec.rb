require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::StorageSystem do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::StorageSystem
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300)
      expect(item[:type]).to eq('StorageSystemV3')
    end
  end

  describe '#add' do
    it 'sends just the credentials hash, then the rest of the data' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(
        @client_300,
        name: 'Fake',
        credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' }
      )
      expect(@client_300).to receive(:rest_post).with('/rest/storage-systems', { 'body' => item['credentials'] }, item.api_version)
        .and_return(FakeResponse.new('uri' => '/rest/task/fake'))
      allow(@client_300).to receive(:wait_for)
        .and_return(FakeResponse.new(nil, 300, 'associatedResource' => { 'resourceUri' => '/rest/fake' }))
      expect(item).to receive(:refresh).and_return(true)
      expect(item).to receive(:update).with('name' => 'Fake', 'type' => 'StorageSystemV3').and_return(true)
      item.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      storage = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, uri: '/rest/storage-systems/100')
      expect(@client_300).to receive(:rest_delete).with('/rest/storage-systems/100', {}, 300).and_return(FakeResponse.new({}))
      storage.remove
    end
  end

  describe '#retrieve!' do
    it 'finds by name if it is set' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, name: 'Fake')
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client_300, 'name' => 'Fake').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'finds by credentials if the name is not set' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(
        @client_300,
        credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' }
      )
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client_300, credentials: { ip_hostname: 'a.com' }).and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'no parameter given' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#exists?' do
    it 'finds by name if it is set' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, name: 'Fake')
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client_300, 'name' => 'Fake').and_return([item])
      expect(item.exists?).to eq(true)
    end

    it 'finds by credentials if the name is not set' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(
        @client_300,
        credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' }
      )
      expect(OneviewSDK::Resource).to receive(:find_by).with(@client_300, credentials: { ip_hostname: 'a.com' }).and_return([item])
      expect(item.exists?).to eq(true)
    end

    it 'no parameter given' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, {})
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
      item = OneviewSDK::API300::Synergy::StorageSystem.new(
        @client,
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
      item = OneviewSDK::API300::Synergy::StorageSystem.new(
        @client,
        'name' => 'StorageSystemName',
        'credentials' => {
          'ip_hostname' => '127.0.0.1',
          'username' => 'user'
        },
        'state' => 'Configured'
      )
      expect(item.like?(options)).to eq(true)
    end

    it 'must not compare storage system credentials with password when compares resources ' do
      options1 = { name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin' } }
      options2 = { name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin', password: 'secret' } }
      item1 = OneviewSDK::API300::Synergy::StorageSystem.new(@client, options1)
      item2 = OneviewSDK::API300::Synergy::StorageSystem.new(@client, options2)
      expect(item1.like?(item2)).to eq(true)
    end

    it 'must not compare storage system with invalid data types' do
      options = { name: 'Fake', credentials: { ip_hostname: 'a.com', username: 'admin' } }
      item1 = OneviewSDK::API300::Synergy::StorageSystem.new(@client, options)
      expect(item1.like?(credentials: true)).to eq(false)
    end
  end

  describe '#host-types' do
    it 'List Host Types' do
      expect(@client_300).to receive(:rest_get).with('/rest/storage-systems/host-types').and_return(FakeResponse.new({}))
      expect { OneviewSDK::API300::Synergy::StorageSystem.get_host_types(@client_300) }.not_to raise_error
    end
  end

  describe '#storage pools' do
    it 'List Storage Pools' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/storage-pools').and_return(FakeResponse.new({}))
      expect { item.get_storage_pools }.not_to raise_error
    end
  end

  describe '#get_managed_ports' do
    it 'No port given' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/managedPorts').and_return(FakeResponse.new({}))
      item.get_managed_ports
    end

    it 'With port given' do
      item = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/managedPorts/100').and_return(FakeResponse.new({}))
      item.get_managed_ports(100)
    end
  end

  describe 'undefined methods' do
    it 'does not allow the create action' do
      storage = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300)
      expect { storage.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      storage = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300)
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
      storage = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, options)
      storage_updated = OneviewSDK::API300::Synergy::StorageSystem.new(@client_300, options_update)
      allow_any_instance_of(OneviewSDK::API300::Synergy::StorageSystem).to receive(:update).and_return(FakeResponse.new(storage_updated))
      expect { storage.set_refresh_state('RefreshPending') }.not_to raise_error
      expect(storage['refreshState']).to eq('RefreshPending')
    end
  end
end
