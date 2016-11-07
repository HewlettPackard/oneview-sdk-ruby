require 'spec_helper'

klass = OneviewSDK::API300::C7000::StoragePool
RSpec.describe klass, integration: true, type: UPDATE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#update' do
    it 'should throw unavailable method error' do
      item = klass.new($client_300, name: STORAGE_POOL_NAME)
      item.retrieve!
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
