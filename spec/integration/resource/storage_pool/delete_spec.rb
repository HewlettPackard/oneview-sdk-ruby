require 'spec_helper'

klass = OneviewSDK::StoragePool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#remove' do
    it 'deletes the resource' do
      item = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
      item.retrieve!
      expect { item.remove }.to_not raise_error
    end
  end
end
