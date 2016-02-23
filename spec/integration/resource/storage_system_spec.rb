require 'spec_helper'

RSpec.describe OneviewSDK::StorageSystem, integration: true do
  include_context 'integration context'

  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: '172.18.11.11',
        username: 'dcs',
        password: 'dcs'
      },
      managedDomain: 'TestDomain'
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::StorageSystem.new(@client, storage_system_data)
      item.create
      expect(item[:uri]).not_to be_empty
    end
  end

  describe '#host-types' do
    it 'List Host Types' do
      expect { OneviewSDK::StorageSystem.host_types(@client) }.not_to raise_error
    end
  end

  describe '#storage pools' do
    it 'List Storage Pools' do
      storage = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: storage_system_data[:credentials][:ip_hostname] })
      storage.retrieve!
      expect { storage.storage_pools }.not_to raise_error
    end
  end

  describe '#managedPorts' do
    it '' do
      storage = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: storage_system_data[:credentials][:ip_hostname] })
      storage.retrieve!
      expect { storage.managedPorts }.not_to raise_error
    end
  end

end
