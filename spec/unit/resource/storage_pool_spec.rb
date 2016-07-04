require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      profile = OneviewSDK::StoragePool.new(@client)
      expect(profile[:type]).to eq('StoragePoolV2')
    end
  end

  describe '#set_storage_system' do
    it 'sets the storageSystemUri value' do
      item = OneviewSDK::StoragePool.new(@client)
      item.set_storage_system(OneviewSDK::StorageSystem.new(@client, uri: '/rest/fake'))
      expect(item['storageSystemUri']).to eq('/rest/fake')
    end

    it 'requires a storage_system with a uri' do
      item = OneviewSDK::StoragePool.new(@client)
      expect { item.set_storage_system(OneviewSDK::StorageSystem.new(@client)) }.to raise_error(OneviewSDK::IncompleteResource, /Please set/)
    end
  end

  describe 'undefined methods' do
    it 'does not allow the update action' do
      storage_pool = OneviewSDK::StoragePool.new(@client)
      expect { storage_pool.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end
  end
end
