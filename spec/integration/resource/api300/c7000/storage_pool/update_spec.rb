require 'spec_helper'

klass = OneviewSDK::API300::C7000::StoragePool
RSpec.describe klass, integration: true, type: UPDATE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  let(:file_path) { 'spec/support/fixtures/integration/storage_pool.json' }

  describe '#update' do
    it 'should throw unavailable method error' do
      item = klass.from_file($client_300, file_path)
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
