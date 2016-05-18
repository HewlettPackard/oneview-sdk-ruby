require 'spec_helper'

RSpec.describe OneviewSDK::LogicalSwitch, integration: true, type: CREATE, sequence: 14 do
  include_context 'integration context'

  before :all do
    @item = OneviewSDK::LogicalSwitch.new($client, name: LOG_SWI_NAME)
  end

  describe '#create' do
    it 'Logical switch create' do
      ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new($secrets['logical_switch_ssh_user'], $secrets['logical_switch_ssh_password'])
      snmp_v1 = OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(161, 'public')
      logical_switch_group = OneviewSDK::LogicalSwitchGroup.new($client, name: LOG_SWI_GROUP_NAME)
      logical_switch_group.retrieve!
      @item.set_logical_switch_group(logical_switch_group)
      @item.set_switch_credentials($secrets['logical_switch1_ip'], ssh_credentials, snmp_v1)
      @item.set_switch_credentials($secrets['logical_switch2_ip'], ssh_credentials, snmp_v1)
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
