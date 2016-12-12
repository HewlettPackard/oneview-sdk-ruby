require 'spec_helper'

klass = OneviewSDK::API300::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:storage_system_data) do
    {
      credentials: {
        ip_hostname: $secrets_synergy['storage_system1_ip'],
        username: $secrets_synergy['storage_system1_user'],
        password: $secrets_synergy['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = klass.new($client_300_synergy, storage_system_data)
      item.add
      expect(item[:uri]).not_to be_empty
    end
  end

  describe '#host-types' do
    it 'List Host Types' do
      expect { klass.get_host_types($client_300_synergy) }.not_to raise_error
    end
  end

  describe '#storage pools' do
    it 'List Storage Pools' do
      storage = klass.new($client_300_synergy, credentials: { ip_hostname: storage_system_data[:credentials][:ip_hostname] })
      storage.retrieve!
      expect { storage.get_storage_pools }.not_to raise_error
    end
  end

  describe '#get_managed_ports' do
    it 'lists all the ports' do
      storage = klass.new($client_300_synergy, credentials: { ip_hostname: storage_system_data[:credentials][:ip_hostname] })
      storage.retrieve!
      expect { storage.get_managed_ports }.not_to raise_error
    end
  end

  describe '#retrieve' do
    it 'raises an exception if no identifiers are given' do
      storage = klass.new($client_300_synergy, {})
      expect { storage.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end

    it 'not retrieves storage system with ip_hostname and invalid data types' do
      storage = klass.new($client_300_synergy, 'credentials' => {})
      storage['credentials']['ip_hostname'] = 'fake'
      storage.retrieve!
      expect(storage.retrieve!).to eq(false)
    end
  end
end
