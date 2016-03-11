require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool, integration: true do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }
  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: '172.18.11.11'
      }
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::StoragePool.from_file(@client, file_path)
      item.create
      storage_system = OneviewSDK::StorageSystem.new(@client, storage_system_data)
      storage_system.retrieve!
      expect(item[:storageSystemUri]).to eq(storage_system['uri'])
      expect(item[:poolName]).to eq('CPG-SSD-AO')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::StoragePool.new(@client, name: 'CPG-SSD-AO')
      item.retrieve!
      storage_system = OneviewSDK::StorageSystem.new(@client, storage_system_data)
      storage_system.retrieve!
      expect(item[:storageSystemUri]).to eq(storage_system['uri'])
      expect(item[:name]).to eq('CPG-SSD-AO')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::StoragePool.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include('CPG-SSD-AO')
    end

    it 'finds storage pools by multiple attributes' do
      storage_system = OneviewSDK::StorageSystem.new(@client, storage_system_data)
      storage_system.retrieve!
      attrs = { name: 'CPG-SSD-AO', storageSystemUri: storage_system['uri'] }
      names = OneviewSDK::StoragePool.find_by(@client, attrs).map { |item| item[:name] }
      expect(names).to include('CPG-SSD-AO')
    end
  end

  # describe '#delete' do
  #   it 'deletes the resource' do
  #     item = OneviewSDK::StoragePool.new(@client, name: 'CPG-SSD-AO')
  #     item.retrieve!
  #     item.delete
  #   end
  # end

end
