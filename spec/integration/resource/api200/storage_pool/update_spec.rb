require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }

  describe '#update' do
    it 'should throw unavailable method error' do
      item = OneviewSDK::StoragePool.from_file($client, file_path)
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
