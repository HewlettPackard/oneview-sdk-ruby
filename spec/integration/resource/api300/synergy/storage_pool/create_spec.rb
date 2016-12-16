require 'spec_helper'

klass = OneviewSDK::API300::Synergy::StoragePool
storage_system_klass = OneviewSDK::API300::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }
  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip']
      }
    }
  end

  describe '#create' do
    it 'should throw unavailable exception' do
      item = klass.from_file($client_300_synergy, file_path)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#add' do
    it 'can add resources' do
      item = klass.from_file($client_300_synergy, file_path)
      item.add
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
      expect(item['poolName']).to eq(STORAGE_POOL_NAME)
      expect(item['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      storage_system_ref = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system_ref.retrieve!
      item = klass.new($client_300_synergy, name: STORAGE_POOL_NAME, storageSystemUri: storage_system_ref['uri'])
      item.retrieve!
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
      expect(item['name']).to eq(STORAGE_POOL_NAME)
      expect(item['uri']).to be
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = klass.find_by($client_300_synergy, {}).map { |item| item['name'] }
      expect(names).to include(STORAGE_POOL_NAME)
    end

    it 'finds storage pools by multiple attributes' do
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      attrs = { name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'] }
      names = klass.find_by($client_300_synergy, attrs).map { |item| item['name'] }
      expect(names).to include(STORAGE_POOL_NAME)
    end
  end

  describe '#set_storage_system' do
    it 'can set storage system before add storage pool' do
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      item = klass.new($client_300_synergy)

      expect(item.set_storage_system(storage_system)).to eq(storage_system['uri'])
      expect(item['storageSystemUri']).to eq(storage_system['uri'])
    end

    it 'should throw incomplete resource exception if storage system\'s uri is unknown' do
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      item = klass.new($client_300_synergy)

      expect { item.set_storage_system(storage_system) }.to raise_error(OneviewSDK::IncompleteResource)
      expect { item.set_storage_system(storage_system) }.to raise_error(/Please set the storage system\'s uri attribute!/)
    end
  end

  describe '#exists?' do
    it 'returns true if storage pool exists' do
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      item = klass.new($client_300_synergy, name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'])

      expect(item.exists?).to eq(true)
    end

    it 'returns false if storage pool not exists' do
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      item = klass.new($client_300_synergy, name: 'some unknown nama', storageSystemUri: storage_system['uri'])

      expect(item.exists?).to eq(false)
    end

    it 'should throw incomplete resource exception if name and uri or storageSystemUri are unknown' do
      storage_system = storage_system_klass.new($client_300_synergy, storage_system_data)
      storage_system.retrieve!
      item_without_name_and_uri = klass.new($client_300_synergy, storageSystemUri: storage_system['uri'])
      item_without_storage_system_uri = klass.new($client_300_synergy, name: 'some unknown nama')

      expect { item_without_name_and_uri.exists? }.to raise_error(OneviewSDK::IncompleteResource)
      expect { item_without_name_and_uri.exists? }.to raise_error(/Must set resource name or uri before trying to exists?/)

      expect { item_without_storage_system_uri.exists? }.to raise_error(OneviewSDK::IncompleteResource)
      expect { item_without_storage_system_uri.exists? }.to raise_error(/Must set resource storageSystemUri before trying to exists?/)
    end
  end
end
