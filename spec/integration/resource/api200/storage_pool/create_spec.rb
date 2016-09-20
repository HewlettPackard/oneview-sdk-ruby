require 'spec_helper'

klass = OneviewSDK::StoragePool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }
  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip']
      }
    }
  end

  describe '#add' do
    it 'can add resources' do
      item = OneviewSDK::StoragePool.from_file($client, file_path)
      item.add
      storage_system = OneviewSDK::StorageSystem.new($client, storage_system_data)
      storage_system.retrieve!
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
      expect(item['poolName']).to eq(STORAGE_POOL_NAME)
      expect(item['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
      item.retrieve!
      storage_system = OneviewSDK::StorageSystem.new($client, storage_system_data)
      storage_system.retrieve!
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
      expect(item['name']).to eq(STORAGE_POOL_NAME)
      expect(item['uri']).to be
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::StoragePool.find_by($client, {}).map { |item| item['name'] }
      expect(names).to include(STORAGE_POOL_NAME)
    end

    it 'finds storage pools by multiple attributes' do
      storage_system = OneviewSDK::StorageSystem.new($client, storage_system_data)
      storage_system.retrieve!
      attrs = { name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'] }
      names = OneviewSDK::StoragePool.find_by($client, attrs).map { |item| item['name'] }
      expect(names).to include(STORAGE_POOL_NAME)
    end
  end
end
