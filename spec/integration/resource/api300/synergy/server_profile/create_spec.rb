# Requirements:
# => 2 Server Hardware Types (any name)
# => Enclosure Group 'EnclosureGroup_1' (configured for work with Deployment Network)
# => Storage System (any name)
# => FC Network 'FCNetwork_1' (it has to be associated to the LIG 'EnclosureGroup_1' is associated to)
# => Volume 'Volume_4'
# => Storage Pool 'CPG-SSD-AO'
# => Server Profile Template (any name)
# => OS Deployment Plan 'HPE - Developer 1.0 - Deployment Test (UEFI)'

require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'can create a basic connection-less unassigned server profile' do
      item = klass.new($client_300_synergy, name: SERVER_PROFILE_NAME)
      server_hardware_type = OneviewSDK::API300::Synergy::ServerHardwareType.find_by($client_300_synergy, {}).first
      enclosure_group = OneviewSDK::API300::Synergy::EnclosureGroup.find_by($client_300_synergy, name: ENC_GROUP_NAME).first
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      expect { item.create }.to_not raise_error
    end

    it 'can be created from template' do
      template = OneviewSDK::API300::Synergy::ServerProfileTemplate.find_by($client_300_synergy, {}).first
      item = template.new_profile(SERVER_PROFILE2_NAME)
      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
    end

    it 'can create advanced server profile with connections and volume attachments' do
      item = klass.new($client_300_synergy, name: SERVER_PROFILE3_NAME)

      server_hardware_type = OneviewSDK::API300::Synergy::ServerHardwareType.find_by($client_300_synergy, {}).first
      item.set_server_hardware_type(server_hardware_type)

      enclosure_group = OneviewSDK::API300::Synergy::EnclosureGroup.new($client_300_synergy, name: ENC_GROUP_NAME)
      item.set_enclosure_group(enclosure_group)

      expect(enclosure_group['uri']).to be
      expect(server_hardware_type['uri']).to be

      storage_system = OneviewSDK::API300::Synergy::StorageSystem.find_by($client_300_synergy, {}).first
      expect(storage_system['uri']).to be

      available_fc_network = OneviewSDK::API300::Synergy::FCNetwork.new($client_300_synergy, name: FC_NET_NAME)
      available_fc_network.retrieve!
      item.add_connection(available_fc_network, 'name' => 'fc_con_1', 'functionType' => 'FibreChannel', 'portId' => 'Auto')

      volume_params = {
        'name' => VOLUME4_NAME,
        'provisioningParameters' => {
          'provisionType' => 'Full',
          'shareable' => true,
          'requestedCapacity' => 1024 * 1024 * 1024
        }
      }

      storage_pool = OneviewSDK::API300::Synergy::StoragePool.new($client_300_synergy, name: STORAGE_POOL_NAME)
      item.create_volume_with_attachment(storage_pool, volume_params)
      item['sanStorage']['manageSanStorage'] = true
      item['sanStorage']['hostOSType'] = 'Windows 2012 / WS2012 R2'

      expect { item.create }.to_not raise_error
    end
  end

  describe '#get_available_networks' do
    it 'Gets available networks' do
      item = klass.find_by($client_300_synergy, name: SERVER_PROFILE_NAME).first
      expect { item.get_available_networks }.not_to raise_error
    end
  end

  describe '#set_os_deployment_setttings' do
    it 'Should work properly (it will fail if the there is not a OS Deployment Plan)' do
      item = klass.new($client_300_synergy, name: SERVER_PROFILE_WITH_OSDP_NAME)

      # get values for set in ServerProfile
      server_hardware_type = OneviewSDK::API300::Synergy::ServerHardwareType.get_all($client_300_synergy).first
      enclosure_group = OneviewSDK::API300::Synergy::EnclosureGroup.get_all($client_300_synergy).first
      os_deployment_plan = OneviewSDK::API300::Synergy::OSDeploymentPlan.find_by($client_300_synergy, name: OS_DEPLOYMENT_PLAN_NAME).first
      deployment_network_uri = enclosure_group['osDeploymentSettings']['deploymentModeSettings']['deploymentNetworkUri']
      network_options = { enclosureGroupUri: enclosure_group['uri'], serverHardwareTypeUri: server_hardware_type['uri'], view: 'Ethernet' }
      networks = OneviewSDK::API300::Synergy::ServerProfile.get_available_networks($client_300_synergy, network_options)['ethernetNetworks']
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
end
