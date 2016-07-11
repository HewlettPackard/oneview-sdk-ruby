require 'spec_helper'

klass = OneviewSDK::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'can create a basic connection-less assigned server profile' do
      item = OneviewSDK::ServerProfile.new($client, name: SERVER_PROFILE_NAME)
      target = OneviewSDK::ServerProfile.get_available_targets($client)['targets'].first
      server_hardware = OneviewSDK::ServerHardware.new($client, uri: target['serverHardwareUri'])
      item.set_server_hardware(server_hardware)
      expect { item.create }.to_not raise_error
    end

    it 'can create a basic connection-less unassigned server profile' do
      item = OneviewSDK::ServerProfile.new($client, name: SERVER_PROFILE2_NAME)
      target = OneviewSDK::ServerProfile.get_available_targets($client)['targets'].first
      server_hardware_type = OneviewSDK::ServerHardwareType.new($client, uri: target['serverHardwareTypeUri'])
      item.set_server_hardware_type(server_hardware_type)
      expect { item.create }.to_not raise_error
    end

    it 'can be created from template' do
      template = OneviewSDK::ServerProfileTemplate.find_by($client, {}).first
      item = template.new_profile(SERVER_PROFILE3_NAME)
      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
    end

    it 'can create advanced server profile with connections and volume attachments' do
      item = OneviewSDK::ServerProfile.new($client, name: SERVER_PROFILE4_NAME)

      server_hardware_type = OneviewSDK::ServerHardwareType.new($client, name: 'BL460c Gen8 1')
      item.set_server_hardware_type(server_hardware_type)

      enclosure_group = OneviewSDK::EnclosureGroup.new($client, name: ENC_GROUP2_NAME)
      item.set_enclosure_group(enclosure_group)

      association_params = { 'enclosure_group' => enclosure_group, 'server_hardware_type' => server_hardware_type }

      expect(enclosure_group['uri']).to be
      expect(server_hardware_type['uri']).to be

      storage_system = OneviewSDK::StorageSystem.find_by($client, {}).first
      expect(storage_system['uri']).to be

      available_fc_network = OneviewSDK::FCNetwork.new($client, name: FC_NET_NAME)
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

      storage_pool = OneviewSDK::StoragePool.new($client, name: STORAGE_POOL_NAME)
      item.create_volume_with_attachment(storage_pool, volume_params)
      item['sanStorage']['manageSanStorage'] = true
      item['sanStorage']['hostOSType'] = 'Windows 2012 / WS2012 R2'

      expect { item.create }.to_not raise_error
    end
  end
end
