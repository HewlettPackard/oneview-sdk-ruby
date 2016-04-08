require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool, integration: true, type: DELETE, sequence: 2 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
      item.retrieve!
      expect { item.delete }.to_not raise_error
    end
  end
end
