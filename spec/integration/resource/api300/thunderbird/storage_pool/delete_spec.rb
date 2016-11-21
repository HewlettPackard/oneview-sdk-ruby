require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::StoragePool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

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
      item = klass.from_file($client_300_thunderbird, file_path)
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#remove' do
    it 'deletes the resource' do
      storage_system_ref = OneviewSDK::API300::Thunderbird::StorageSystem.new($client_300_thunderbird, storage_system_data)
      storage_system_ref.retrieve!
      item = klass.new($client_300_thunderbird, name: STORAGE_POOL_NAME, storageSystemUri: storage_system_ref['uri'])
      item.retrieve!

      expect { item.remove }.to_not raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
