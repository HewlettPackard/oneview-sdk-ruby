require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitch, integration: true, type: CREATE, sequence: 14 do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitch.new($client, name: LOG_SWI_NAME)
  end

  describe '#create' do
    it 'Logical switch create' do
      ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new('dcs', 'dcs')
      snmp_v1 = OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(161, 'public')
      logical_switch_group = OneviewSDK::LogicalSwitchGroup.new($client, name: 'Teste')
      logical_switch_group.retrieve!
      @item.set_logical_switch_group(logical_switch_group)
      @item.set_switch_credentials('172.18.20.1', ssh_credentials, snmp_v1)
      @item.set_switch_credentials('172.18.20.2', ssh_credentials, snmp_v1)
      @item.create
      expect(@item['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      @item = OneviewSDK::LogicalSwitch.new($client, name: LOG_SWI_NAME)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end

end
