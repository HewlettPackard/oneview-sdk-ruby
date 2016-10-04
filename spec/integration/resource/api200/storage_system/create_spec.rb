require 'spec_helper'

klass = OneviewSDK::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip'],
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::StorageSystem.new($client, storage_system_data)
      item.add
      expect(item[:uri]).not_to be_empty
    end
  end

  describe '#host-types' do
    it 'List Host Types' do
      expect { OneviewSDK::StorageSystem.get_host_types($client) }.not_to raise_error
    end
  end

  describe '#storage pools' do
    it 'List Storage Pools' do
      storage = OneviewSDK::StorageSystem.new($client, credentials: { ip_hostname: storage_system_data[:credentials][:ip_hostname] })
      storage.retrieve!
      expect { storage.get_storage_pools }.not_to raise_error
    end
  end

  describe '#get_managed_ports' do
    it 'lists all the ports' do
      storage = OneviewSDK::StorageSystem.new($client, credentials: { ip_hostname: storage_system_data[:credentials][:ip_hostname] })
      storage.retrieve!
      expect { storage.get_managed_ports }.not_to raise_error
    end
  end
end
