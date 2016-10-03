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
