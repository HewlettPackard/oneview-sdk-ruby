# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'LogicalSwitchCreateExample' do |context_name|
  include_context context_name

  context 'create actions' do
    let(:item) { described_class.new(current_client, name: LOG_SWI_NAME) }
    let(:logical_switch_group) { logical_switch_group_class.new(current_client, name: LOG_SWI_GROUP_NAME) }

    before do
      logical_switch_group.retrieve!
      ssh_credentials = described_class::CredentialsSSH.new($secrets['logical_switch_ssh_user'], $secrets['logical_switch_ssh_password'])
      snmp_v1 = described_class::CredentialsSNMPV1.new(161, $secrets['logical_switch_community_string'])
      item.set_logical_switch_group(logical_switch_group)
      item.set_switch_credentials($secrets['logical_switch1_ip'], ssh_credentials, snmp_v1)
      item.set_switch_credentials($secrets['logical_switch2_ip'], ssh_credentials, snmp_v1)
    end

    describe '#create' do
      it 'creates a logical switch' do
        item.create
        expect(item['uri']).to be
      end
    end

    describe '#create!' do
      it 'creates a logical switch' do
        item.create!
        expect(item.retrieve!).to eq(true)
        list = described_class.find_by(current_client, name: LOG_SWI_NAME)
        expect(list.size).to eq(1)
      end
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      item = described_class.new(current_client, name: LOG_SWI_NAME)
      item.retrieve!
      expect(item['uri']).to be
    end
  end
end
