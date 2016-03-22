require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool, integration: true, type: DELETE, sequence: 3 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
      item.retrieve!
      item.delete
    end
  end
end
