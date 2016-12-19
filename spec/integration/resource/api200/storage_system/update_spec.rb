require 'spec_helper'

klass = OneviewSDK::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:options) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip'],
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }
  end

  let(:options_2) do
    {
      'credentials' => {
        'ip_hostname' => $secrets['storage_system1_ip'],
        'username' => $secrets['storage_system1_user'],
        'password' => $secrets['storage_system1_password']
      },
      'managedDomain' => 'TestDomain'
    }
  end

  describe '#update' do
    it '#updating fc_network unmanaged ports' do
      storage_system = klass.new($client, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!

      fc_network = OneviewSDK::FCNetwork.find_by($client, {}).first

      storage_system.data['unmanagedPorts'].first['expectedNetworkUri'] = fc_network.data['uri']
      storage_system.update
      new_item = klass.new($client, 'credentials' => {})
      new_item['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      new_item.retrieve!
      list = new_item.data['unmanagedPorts'].select { |a| a['expectedNetworkUri'] == fc_network['uri'] }
      expect(list).not_to be_empty
    end
  end

  describe '#set_refresh_state' do
    it 'Refreshing a storage system' do
      storage_system = klass.find_by($client, credentials: { ip_hostname: $secrets['storage_system1_ip'] }).first
      expect { storage_system.set_refresh_state('RefreshPending') }.not_to raise_error
      expect(storage_system['refreshState']).to eq('RefreshPending')
    end
  end

  describe '#like?' do
    it 'must not compare storage system credentials with password and hash String' do
      storage_system = klass.new($client, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!
      expect(storage_system.like?(options)).to eq(true)
    end

    it 'must not compare storage system credentials with password and key Symbol' do
      storage_system = klass.new($client, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!
      expect(storage_system.like?(options_2)).to eq(true)
    end

    it 'must not compare storage system credentials with password when compares resources' do
      storage_system = klass.new($client, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!
      item2 = klass.new($client, options)
      expect(storage_system.like?(item2)).to eq(true)
    end

    it 'must not compare storage system with invalid data types' do
      storage_system = klass.new($client, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!
      expect(storage_system.like?(credentials: true)).to eq(false)
    end
  end

  describe '#exists?' do
    it 'finds it by managedDomain' do
      expect(klass.new($client, options_2).exists?).to be true
      expect(klass.new($client, managedDomain: 'fake', credentials: { ip_hostname: 'fake' }).exists?).to be false
    end

    it 'finds it by credentials' do
      expect(klass.new($client, credentials: { ip_hostname: $secrets['storage_system1_ip'] }).exists?).to be true
      expect(klass.new($client, credentials: { ip_hostname: 'fake' }).exists?).to be false
    end

    it 'raises an exception if no identifiers are given' do
      item = klass.new($client, {})
      expect { item.exists? }.to raise_error(OneviewSDK::IncompleteResource)
    end
    it 'raises an exception when ip_hostname is not passed' do
      item = klass.new($client, credentials: {})
      expect { item.exists? }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end
end
