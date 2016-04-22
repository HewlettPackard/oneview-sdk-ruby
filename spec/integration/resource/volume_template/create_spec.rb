require 'spec_helper'

RSpec.describe OneviewSDK::VolumeTemplate, integration: true, type: CREATE, sequence: 12 do
  include_context 'integration context'

  before :all do
    storage_system_data = { credentials: { ip_hostname: $secrets['storage_system1_ip'] } }
    @storage_system = OneviewSDK::StorageSystem.new($client, storage_system_data)
    @storage_system.retrieve!
    @storage_pool = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
    @storage_pool.retrieve!
  end

  describe '#create' do
    it 'can create resources' do
      options = {
        name: VOL_TEMP_NAME,
        state: 'Normal',
        description: 'Volume Template',
        type: 'StorageVolumeTemplateV3'
      }

      item = OneviewSDK::VolumeTemplate.new($client, options)
      item.set_provisioning(true, 'Thin', 2 * 1024 * 1024 * 1024, @storage_pool)
      item.set_storage_system(@storage_system)
      item.set_snapshot_pool(@storage_pool)

      expect { item.create }.to_not raise_error
      expect(item[:name]).to eq(VOL_TEMP_NAME)
      expect(item[:description]).to eq('Volume Template')
      expect(item[:stateReason]).to eq('None')
      expect(item[:type]).to eq('StorageVolumeTemplateV3')
    end
  end
end
