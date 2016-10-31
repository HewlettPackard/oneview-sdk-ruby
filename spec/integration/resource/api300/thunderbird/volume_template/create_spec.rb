require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::VolumeTemplate
extra_klass_1 = OneviewSDK::API300::Thunderbird::StorageSystem
extra_klass_2 = OneviewSDK::API300::Thunderbird::StoragePool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    storage_system_options = {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip'],
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }

    @storage_system = extra_klass_1.new($client_300, storage_system_options)
    @storage_system.add unless @storage_system.retrieve!
    @storage_system.retrieve!

    storage_pool_options = {
      storageSystemUri: @storage_system['uri'],
      poolName: STORAGE_POOL_NAME
    }
    @storage_pool = extra_klass_2.new($client_300, storage_pool_options)
    puts '********************************'
    puts @storage_pool.inspect
    @storage_pool.add unless @storage_pool.retrieve!
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

      item = klass.new($client_300, options)
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
