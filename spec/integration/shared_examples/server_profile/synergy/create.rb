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

RSpec.shared_examples 'ServerProfileCreateExample Synergy' do |context_name|
  include_context context_name

  describe '#set_os_deployment_setttings' do
    it 'Should work properly (it will fail if the there is not a OS Deployment Plan)' do
      item = described_class.new(current_client, name: SERVER_PROFILE_WITH_OSDP_NAME)

      # get values for set in ServerProfile
      server_hardware_type = resource_class_of('ServerHardwareType').get_all(current_client).first
      enclosure_group = resource_class_of('EnclosureGroup').get_all(current_client).first
      os_deployment_plan = resource_class_of('OSDeploymentPlan').find_by(current_client, name: OS_DEPLOYMENT_PLAN_NAME).first
      deployment_network_uri = enclosure_group['osDeploymentSettings']['deploymentModeSettings']['deploymentNetworkUri']
      network_options = { enclosureGroupUri: enclosure_group['uri'], serverHardwareTypeUri: server_hardware_type['uri'], view: 'Ethernet' }
      networks = described_class.get_available_networks(current_client, network_options)['ethernetNetworks']
      network = networks.find { |netw| netw['uri'] == deployment_network_uri }

      # set in ServerProfile necessary values for create it with the OSDeploymentPlan
      item.add_connection(network, 'name' => 'deploy', 'functionType' => 'Ethernet', 'boot' => { 'priority' => 'Primary' })
      item['boot'] = { 'manageBoot' => true, 'order' => ['HardDisk'] }
      item['bootMode'] = { 'manageMode' => true, 'mode' => 'UEFIOptimized', 'pxeBootPolicy' => 'Auto' }
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)

      # the method target of this test
      item.set_os_deployment_setttings(os_deployment_plan)

      expect { item.create }.not_to raise_error
      expect(item['uri']).to be
    end
  end

  describe '#self.get_sas_logical_jbods' do
    it 'Gets a collection of SAS logical JBODs' do
      expect { described_class.get_sas_logical_jbods(current_client) }.not_to raise_error
    end
  end

  describe '#self.get_sas_logical_jbod' do
    it 'Gets a SAS logical JBODs by name' do
      expect { described_class.get_sas_logical_jbod(current_client, 'any') }.not_to raise_error
    end
  end

  describe '#self.get_sas_logical_jbod_attachments' do
    it 'Gets a collection of SAS logical JBODs attachments' do
      expect { described_class.get_sas_logical_jbod_attachments(current_client) }.not_to raise_error
    end
  end

  describe '#self.get_sas_logical_jbod_attachment' do
    it 'Gets a SAS logical JBODs attachment by name' do
      expect { described_class.get_sas_logical_jbod_attachment(current_client, 'any') }.not_to raise_error
    end
  end
end
