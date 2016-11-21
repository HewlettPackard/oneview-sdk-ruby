require 'spec_helper'

klass = OneviewSDK::StoragePool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }
  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip']
      }
    }
  end

  describe '#delete' do
    it 'should throw unavailable exception' do
      item = OneviewSDK::StoragePool.from_file($client, file_path)
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#remove' do
    it 'deletes the resource' do
      storage_system_ref = OneviewSDK::StorageSystem.new($client, storage_system_data)
      storage_system_ref.retrieve!
      item = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME, storageSystemUri: storage_system_ref['uri'])
      item.retrieve!

      expect { item.remove }.to_not raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
