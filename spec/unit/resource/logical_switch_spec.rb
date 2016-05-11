require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitch do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        logical_switch = OneviewSDK::LogicalSwitch.new(@client)
        expect(logical_switch[:type]).to eq('logical-switch')
      end
    end
  end

  describe '#refresh' do
    it 'Refresh' do
      item = OneviewSDK::LogicalSwitch.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_put).with("#{item['uri']}/refresh").and_return(FakeResponse.new({}))
      item.refresh
    end
  end

  describe '#set_logical_switch_group' do
    it 'Valid logical switch group' do
      logical_switch_group = { 'uri' => '/rest/fake/logical-switch-groups' }
      item = OneviewSDK::LogicalSwitch.new(@client)
      item.set_logical_switch_group(logical_switch_group)
      expect(item['logicalSwitchGroupUri']).to eq('/rest/fake/logical-switch-groups')
    end
  end

  describe '#set_switch_credentials' do
    it 'Valid structure and host for SNMPv1' do
      item = OneviewSDK::LogicalSwitch.new(@client)
      ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new('ssh_user', 'ssh_password')
      snmp_v1 = OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(161, 'public')
      item.set_switch_credentials('127.0.0.1', ssh_credentials, snmp_v1)
      expect(item.logical_switch_credentials['127.0.0.1'][0]).to eq(ssh_credentials)
      expect(item.logical_switch_credentials['127.0.0.1'][1]).to eq(snmp_v1)
    end

    it 'Valid structure and host for SNMPv3' do
      item = OneviewSDK::LogicalSwitch.new(@client)
      ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new('ssh_user', 'ssh_password')
      snmp_v3 = OneviewSDK::LogicalSwitch::CredentialsSNMPV3.new(161, 'public', 'MD5', 'auth_password', 'AES128', 'privacy_password')
      item.set_switch_credentials('127.0.0.1', ssh_credentials, snmp_v3)
      expect(item.logical_switch_credentials['127.0.0.1'][0]).to eq(ssh_credentials)
      expect(item.logical_switch_credentials['127.0.0.1'][1]).to eq(snmp_v3)
    end

    it 'Invalid SSH crendential parameter' do
      item = OneviewSDK::LogicalSwitch.new(@client)
      SSHFake = Struct.new(:user, :password)
      ssh_credentials = SSHFake.new('ssh_user', 'ssh_password')
      snmp_v1 = OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(161, 'public')
      expect { item.set_switch_credentials('127.0.0.1', ssh_credentials, snmp_v1) }.to raise_error(/Use struct<OneviewSDK::LogicalSwitch::CredentialsSSH>/)
    end

    it 'Invalid SNMP credential parameter' do
      item = OneviewSDK::LogicalSwitch.new(@client)
      ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new('ssh_user', 'ssh_password')
      SNMPFake = Struct.new(:port, :community_string, :version) do
        def version
          'SNMP'
        end
      end
      snmp_v1 = SNMPFake.new(161, 'public')
      expect { item.set_switch_credentials('127.0.0.1', ssh_credentials, snmp_v1) }.to raise_error(/Use struct<OneviewSDK::LogicalSwitch::CredentialsSNMP>/)
    end
  end

  describe '#create' do
    it 'Basic structure' do
      logical_switch = OneviewSDK::LogicalSwitch.new(@client)
      expect(@client).to receive(:rest_post).with(
        '/rest/logical-switches',
        {
          'body' => {
            'logicalSwitch' => {
              'type' => 'logical-switch',
              'switchCredentialConfiguration' => []
            },
            'logicalSwitchCredentials' => []
          }
        },
        200).and_return(FakeResponse.new({}))
      logical_switch.create
    end

    it 'SSH credentials' do
      logical_switch = OneviewSDK::LogicalSwitch.new(@client)
      ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new('ssh_user', 'ssh_password')
      #logical_switch.set_switch_credentials('127.0.0.1', ssh_credentials, )

    end

    it 'SSH and SNMPv1 Credentials' do
      logical_switch = OneviewSDK::LogicalSwitch.new(@client)

    end
  end

end
