require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool, integration: true do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::StoragePool.from_file(@client, file_path)
      item.create
      expect(item[:storageSystemUri]).to eq('/rest/storage-systems/TXQ1000307')
      expect(item[:poolName]).to eq('cpg-growth-limit-1TiB')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::StoragePool.new(@client, name: 'cpg-growth-limit-1TiB')
      item.retrieve!
      expect(item[:storageSystemUri]).to eq('/rest/storage-systems/TXQ1000307')
      expect(item[:poolName]).to eq('cpg-growth-limit-1TiB')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::StoragePool.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include('cpg-growth-limit-1TiB')
    end

    it 'finds storage pools by multiple attributes' do
      attrs = { name: 'cpg-growth-limit-1TiB', storageSystemUri: '/rest/storage-systems/TXQ1000307' }
      names = OneviewSDK::StoragePool.find_by(@client, attrs).map { |item| item[:name] }
      expect(names).to include('cpg-growth-limit-1TiB')
    end
  end

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::StoragePool.new(@client, name: 'cpg-growth-limit-1TiB')
      item.retrieve!
      item.delete
    end
  end

end
