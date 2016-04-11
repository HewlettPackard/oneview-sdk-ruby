require 'spec_helper'

RSpec.describe OneviewSDK::StorageSystem, integration: true, type: DELETE, sequence: 3 do
  include_context 'integration context'

  describe '#delete' do
    it 'removes the storage system' do
      storage_system = OneviewSDK::StorageSystem.new($client, name: STORAGE_SYSTEM_NAME)
      storage_system.retrieve!
      expect { storage_system.delete }.to_not raise_error
    end
  end
end
