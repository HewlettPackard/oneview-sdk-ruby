require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::StoragePool do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::StoragePool
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect(pool['type']).to eq('StoragePoolV2')
    end
  end

  describe '#add' do
    it 'Should support add' do
      pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300, name: 'StoragePool_1')
      expect(@client_300).to receive(:rest_post).with(
        '/rest/storage-pools',
        { 'body' => { 'name' => 'StoragePool_1', 'type' => 'StoragePoolV2' } },
        300
      ).and_return(FakeResponse.new({}))
      pool.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300, uri: '/rest/storage-pools/100')
      expect(@client_300).to receive(:rest_delete).with('/rest/storage-pools/100', {}, 300).and_return(FakeResponse.new({}))
      pool.remove
    end
  end

  describe '#set_storage_system' do
    it 'sets the storageSystemUri value' do
      item = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      item.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      expect(item['storageSystemUri']).to eq('/rest/fake')
    end

    it 'requires a storage_system with a uri' do
      item = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect { item.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300)) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set/)
    end
  end

  describe '#retrieve!' do
    it 'requires the name attribute to be set' do
      storage_pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect { storage_pool.retrieve! }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name or uri before trying to retrieve!/)
    end

    it 'requires the storageSystemUri attribute to be set' do
      storage_pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300, name: 'StoragePoolName')
      expect { storage_pool.retrieve! }.to raise_error(
        OneviewSDK::IncompleteResource,
        /Must set resource storageSystemUri before trying to retrieve!/
      )
    end

    it 'uses the uri attribute when the name is not set' do
      res = OneviewSDK::API300::C7000::StoragePool.new(@client_300, uri: '/rest/fake')
      res.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      expect(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).with(@client_300, uri: res['uri'], storageSystemUri: '/rest/fake')
        .and_return([])
      expect(res.exists?).to eq(false)
    end

    it 'sets the data if the resource is found' do
      res = OneviewSDK::API300::C7000::StoragePool.new(@client_300, name: 'ResourceName')
      res.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      allow(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).and_return([
        OneviewSDK::API300::C7000::StoragePool.new(
          @client_300,
          res.data.merge(uri: '/rest/fake', storageSystemUri: '/rest/fake', description: 'Blah')
        )
      ])
      res.retrieve!
      expect(res['uri']).to eq('/rest/fake')
      expect(res['description']).to eq('Blah')
    end

    it 'returns false when the resource is not found' do
      allow(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).and_return([])
      res = OneviewSDK::API300::C7000::StoragePool.new(@client_300, name: 'ResourceName')
      res.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      expect(res.retrieve!).to eq(false)
    end
  end

  describe '#exists?' do
    it 'requires the name attribute to be set' do
      storage_pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect { storage_pool.exists? }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource name or uri before trying to exists?/)
    end

    it 'requires the storageSystemUri attribute to be set' do
      storage_pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300, name: 'StoragePoolName')
      expect { storage_pool.exists? }.to raise_error(OneviewSDK::IncompleteResource, /Must set resource storageSystemUri before trying to exists?/)
    end

    it 'uses the uri attribute when the name is not set' do
      res = OneviewSDK::API300::C7000::StoragePool.new(@client_300, uri: '/rest/fake')
      res.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      expect(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).with(@client_300, storageSystemUri: '/rest/fake', uri: res['uri'])
        .and_return([])
      expect(res.exists?).to eq(false)
    end

    it 'returns true when the resource is found' do
      res = OneviewSDK::API300::C7000::StoragePool.new(@client_300, name: 'ResourceName')
      res.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      expect(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).with(@client_300, name: res['name'], storageSystemUri: '/rest/fake')
        .and_return([res])
      expect(res.exists?).to eq(true)
    end

    it 'returns false when the resource is not found' do
      res = OneviewSDK::API300::C7000::StoragePool.new(@client_300, uri: '/rest/fake')
      res.set_storage_system(OneviewSDK::API300::C7000::StorageSystem.new(@client_300, uri: '/rest/fake'))
      expect(OneviewSDK::API300::C7000::StoragePool).to receive(:find_by).with(@client_300, uri: res['uri'], storageSystemUri: '/rest/fake')
        .and_return([])
      expect(res.exists?).to eq(false)
    end
  end

  describe 'undefined methods' do
    it 'does not allow the create action' do
      pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect { pool.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      storage_pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect { storage_pool.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      pool = OneviewSDK::API300::C7000::StoragePool.new(@client_300)
      expect { pool.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
