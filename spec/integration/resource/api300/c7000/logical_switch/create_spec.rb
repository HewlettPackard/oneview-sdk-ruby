require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: LOG_SWI_NAME)
  end

  describe '#create' do
    it 'Logical switch create' do
      ssh_credentials = klass::CredentialsSSH.new($secrets['logical_switch_ssh_user'], $secrets['logical_switch_ssh_password'])
      snmp_v1 = klass::CredentialsSNMPV1.new(161, $secrets['logical_switch_community_string'])
      logical_switch_group = OneviewSDK::API300::C7000::LogicalSwitchGroup.new($client_300, name: LOG_SWI_GROUP_NAME)
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
      @item = klass.new($client_300, name: LOG_SWI_NAME)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end

  describe '#get_internal_link_sets' do
    it 'gets the internal link sets' do
      expect { klass.get_internal_link_sets($client_300) }.not_to raise_error
    end
  end
end
