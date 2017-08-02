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

RSpec.shared_examples 'ServerProfileCreateExample' do |context_name|
  include_context context_name

  let(:server_hardware_type) { resource_class_of('ServerHardwareType').find_by(current_client, name: server_hardware_type_name).first }
  let(:enclosure_group) { resource_class_of('EnclosureGroup').find_by(current_client, name: ENC_GROUP2_NAME).first }
  let(:fc_network) { resource_class_of('FCNetwork').find_by(current_client, name: FC_NET_NAME).first }
  let(:fc_network2) { resource_class_of('FCNetwork').find_by(current_client, name: FC_NET2_NAME).first }
  let(:attachment_options) do
    options = {
      id: 1,
      lunType: 'Manual',
      lun: 0,
      storagePaths: [
        {
          isEnabled: true,
          connectionId: 1
        },
        {
          isEnabled: true,
          connectionId: 2
        }
      ]
    }

    if current_client.api_version < 500
      options[:storagePaths].first[:storageTargetType] = 'Auto'
      options[:storagePaths].last[:storageTargetType] = 'Auto'
    else
      options[:storagePaths].first[:targetSelector] = 'Auto'
      options[:storagePaths].last[:targetSelector] = 'Auto'
    end
    options
  end
  api_version = described_class.to_s.split('::')[1]

  describe '#create' do
    it 'can create a basic connection-less unassigned server profile' do
      item = described_class.new(current_client, name: SERVER_PROFILE_NAME)
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      expect { item.create }.to_not raise_error
    end

    it 'can be created from template' do
      template = resource_class_of('ServerProfileTemplate').find_by(current_client, name: SERVER_PROFILE_TEMPLATE_NAME).first
      item = template.new_profile(SERVER_PROFILE2_NAME)
      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
    end

    it 'creates a server profile template with connections' do
      ethernet = resource_class_of('EthernetNetwork').new(current_client, name: ETH_NET_NAME)

      item = described_class.new(current_client, name: SERVER_PROFILE3_NAME)
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      item.add_connection(ethernet, functionType: 'Ethernet', name: CONNECTION_NAME)

      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
      expect(item['name']).to eq(SERVER_PROFILE3_NAME)
      expect(item['connections']).not_to be_empty
      expect(item['connections'].first['name']).to eq(CONNECTION_NAME)
      expect(item['connections'].first['networkUri']).to eq(ethernet['uri'])
    end
  end

  describe '#add_volume_attachment' do
    it 'raises an exception when volume not found' do
      item = described_class.new(current_client, name: 'any')
      volume = resource_class_of('Volume').new(current_client, name: 'any')
      expect { item.add_volume_attachment(volume) }.to raise_error(/Volume not found/)
    end

    it 'creates a server profile template adding volume existing with attachment' do
      volume = resource_class_of('Volume').new(current_client, name: VOLUME2_NAME)
      item = described_class.new(current_client, name: SERVER_PROFILE4_NAME)
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      item.add_connection(fc_network, functionType: 'FibreChannel', name: CONNECTION2_NAME, portId: 'Auto', id: 1)
      item.add_connection(fc_network2, functionType: 'FibreChannel', name: CONNECTION3_NAME, portId: 'Auto', id: 2)

      item.add_volume_attachment(volume, attachment_options)
      item['sanStorage']['hostOSType'] = 'Windows 2012 / WS2012 R2'

      expect { item.create }.to_not raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(SERVER_PROFILE4_NAME)
      expect(item['connections'].size).to eq(2)
      expect(item['sanStorage']['volumeAttachments'].first['storagePaths'].size).to eq(2)
    end
  end

  describe '#create_volume_with_attachment' do
    it 'raises an exception when storage pool not found' do
      item = described_class.new(current_client, name: 'any')
      storage_pool = resource_class_of('StoragePool').new(current_client, name: 'any', storageSystemUri: 'fake')
      expect { item.create_volume_with_attachment(storage_pool, {}) }.to raise_error(/Storage Pool not found/)
    end

    it 'creates a server profile template and a volume with attachment', if: api_version.end_with?('200', '300') do
      storage_system = resource_class_of('StorageSystem').find_by(current_client, credentials: { ip_hostname: storage_system_ip }).first
      storage_pool = resource_class_of('StoragePool').new(current_client, name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'])

      volume_options = {
        name: VOLUME7_NAME,
        description: 'Integration test volume',
        provisioningParameters: {
          provisionType: 'Full',
          requestedCapacity: 1024 * 1024 * 1024,
          shareable: false
        }
      }

      item = described_class.new(current_client, name: SERVER_PROFILE5_NAME)
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      item.add_connection(fc_network, functionType: 'FibreChannel', name: CONNECTION2_NAME, portId: 'Auto', id: 1)
      item.add_connection(fc_network2, functionType: 'FibreChannel', name: CONNECTION3_NAME, portId: 'Auto', id: 2)
      item.create_volume_with_attachment(storage_pool, volume_options, attachment_options)
      item['sanStorage']['manageSanStorage'] = true
      item['sanStorage']['hostOSType'] = 'Windows 2012 / WS2012 R2'

      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
      expect(item['name']).to eq(SERVER_PROFILE5_NAME)
      expect(item['connections'].size).to eq(2)
      expect(item['sanStorage']['volumeAttachments'].first['storagePaths'].size).to eq(2)
      # Checking if the volume was created
      volume = resource_class_of('Volume').new(current_client, name: VOLUME7_NAME)
      expect(volume.retrieve!).to eq(true)
    end

    it 'creates a server profile template and a volume with attachment', if: api_version.end_with?('500') do
      storage_system = resource_class_of('StorageSystem').find_by(current_client, hostname: storage_system_ip).first
      storage_pool = resource_class_of('StoragePool').new(current_client, name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'])

      volume_options = {
        name: VOLUME7_NAME,
        description: 'Volume store serv',
        size: 1024 * 1024 * 1024,
        provisioningType: 'Thin',
        isShareable: false
      }

      item = described_class.new(current_client, name: SERVER_PROFILE5_NAME)
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      item.add_connection(fc_network, functionType: 'FibreChannel', name: CONNECTION2_NAME, portId: 'Auto', id: 1)
      item.add_connection(fc_network2, functionType: 'FibreChannel', name: CONNECTION3_NAME, portId: 'Auto', id: 2)
      item.create_volume_with_attachment(storage_pool, volume_options, attachment_options)
      item['sanStorage']['manageSanStorage'] = true
      item['sanStorage']['hostOSType'] = 'Windows 2012 / WS2012 R2'

      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
      expect(item['name']).to eq(SERVER_PROFILE5_NAME)
      expect(item['connections'].size).to eq(2)
      expect(item['sanStorage']['volumeAttachments'].first['storagePaths'].size).to eq(2)
      # Checking if the volume was created
      volume = resource_class_of('Volume').new(current_client, name: VOLUME7_NAME)
      expect(volume.retrieve!).to eq(true)
    end
  end
end
