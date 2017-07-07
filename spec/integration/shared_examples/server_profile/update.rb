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

RSpec.shared_examples 'ServerProfileUpdateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.new(current_client, name: SERVER_PROFILE_NAME) }
  let(:item2) { described_class.new(current_client, name: SERVER_PROFILE2_NAME) }
  let(:server_hardware_type) { resource_class_of('ServerHardwareType').find_by(current_client, name: server_hardware_type_name).first }
  let(:enclosure_group) { resource_class_of('EnclosureGroup').find_by(current_client, name: ENC_GROUP2_NAME).first }
  let(:storage_system) do
    options = current_client.api_version < 500 ? { credentials: { ip_hostname: storage_system_ip } } : { hostname: storage_system_ip }
    resource_class_of('StorageSystem').find_by(current_client, options).first
  end
  api_version = described_class.to_s.split('::')[1]

  before :each do
    @response = nil
  end

  describe '#update' do
    it 'updates the name' do
      item.retrieve!
      new_name = "#{SERVER_PROFILE_NAME}_Updated"
      expect { item.update(name: new_name) }.to_not raise_error
      item.retrieve!
      expect(item['name']).to eq(new_name)
      # returnig to original name
      expect { item.update(name: SERVER_PROFILE_NAME) }.to_not raise_error
      item.retrieve!
      expect(item['name']).to eq(SERVER_PROFILE_NAME)
    end
  end

  describe '#set_enclosure_group' do
    it 'raises an exception when enclosure group not found' do
      expect { item.set_enclosure_group(resource_class_of('EnclosureGroup').new(current_client, name: 'any')) }
        .to raise_error(/Enclosure Group could not be found/)
    end

    it 'sets the enclosure group' do
      expect { item.set_enclosure_group(enclosure_group) }.to_not raise_error
      expect(item['enclosureGroupUri']).to eq(enclosure_group['uri'])
    end
  end

  describe '#set_enclosure' do
    it 'raises an exception when enclosure not found' do
      expect { item.set_enclosure(resource_class_of('Enclosure').new(current_client, name: 'any')) }.to raise_error(/Enclosure could not be found/)
    end

    it 'sets the enclosure group' do
      enclosure = resource_class_of('Enclosure').get_all(current_client).first
      expect { item.set_enclosure(enclosure) }.to_not raise_error
      expect(item['enclosureUri']).to eq(enclosure['uri'])
    end
  end

  describe '#set_server_hardware' do
    it 'raises an exception when server hardware not found' do
      expect { item.set_server_hardware(resource_class_of('ServerHardware').new(current_client, name: 'any')) }
        .to raise_error(/Server Hardware could not be found/)
    end

    it 'sets the server hardware' do
      server_hardware = resource_class_of('ServerHardware').get_all(current_client).first
      expect { item.set_server_hardware(server_hardware) }.to_not raise_error
      expect(item['serverHardwareUri']).to eq(server_hardware['uri'])
    end
  end

  describe '#set_server_hardware_type' do
    it 'raises an exception when server hardware not found' do
      expect { item.set_server_hardware_type(resource_class_of('ServerHardwareType').new(current_client, name: 'any')) }
        .to raise_error(/Server Hardware Type could not be found/)
    end

    it 'sets the server hardware' do
      server_hardware_type = resource_class_of('ServerHardwareType').get_all(current_client).first
      expect { item.set_server_hardware_type(server_hardware_type) }.to_not raise_error
      expect(item['serverHardwareTypeUri']).to eq(server_hardware_type['uri'])
    end
  end

  describe '#get_server_hardware' do
    it 'retrieves the current server hardware' do
      expect { item.get_server_hardware }.to_not raise_error
    end
  end

  describe '#get_available_hardware' do
    it 'raises an exception when serverHardwareTypeUri is missing' do
      expect { @response = item.get_available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*serverHardwareTypeUri/)
    end

    it 'raises an exception when enclosureGroupUri is missing' do
      item.set_server_hardware_type(server_hardware_type)
      expect { @response = item.get_available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*enclosureGroupUri/)
    end

    it 'retrieves the available hardware' do
      item.set_enclosure_group(enclosure_group)
      item.set_server_hardware_type(server_hardware_type)
      expect { @response = item.get_available_hardware }.to_not raise_error
      expect(@response).not_to be_empty
      expect(@response.first).to be_an_instance_of(resource_class_of('ServerHardware'))
    end
  end

  describe '#self.get_available_networks' do
    it 'retrieves available networks without errors' do
      query_options = {
        'enclosure_group' => enclosure_group,
        'server_hardware_type' => server_hardware_type
      }
      expect { @response = described_class.get_available_networks(current_client, query_options) }.to_not raise_error
      expect(@response['ethernetNetworks']).not_to be_empty
      expect(@response['fcNetworks']).not_to be_empty
    end
  end

  describe '#self.get_available_servers' do
    it 'retrieves available servers without errors' do
      expect { @response = described_class.get_available_servers(current_client) }.to_not raise_error
      expect(@response).not_to be_empty
    end
  end

  describe '#self.get_available_storage_system' do
    it 'retrieves available storage system without errors.' do
      query_options = {
        'enclosure_group' => enclosure_group,
        'server_hardware_type' => server_hardware_type,
        'storage_system' => storage_system
      }
      expect { @response = described_class.get_available_storage_system(current_client, query_options) }.to_not raise_error
      expect(@response['storageSystemUri']).to eq(storage_system['uri'])
    end
  end

  describe '#self.get_available_storage_systems' do
    it 'retrieves available storage systems without errors' do
      query_options = {
        'enclosure_group' => enclosure_group,
        'server_hardware_type' => server_hardware_type
      }
      expect { @response = described_class.get_available_storage_systems(current_client, query_options) }.to_not raise_error
      expect(@response).not_to be_empty
    end
  end

  describe '#self.get_available_targets' do
    it 'retrieves available targets without errors' do
      expect { @response = described_class.get_available_targets(current_client) }.to_not raise_error
      expect(@response['targets']).not_to be_empty
    end
  end

  describe '#self.get_profile_ports' do
    it 'retrieves profile ports without errors' do
      query_options = {
        'enclosure_group' => enclosure_group,
        'server_hardware_type' => server_hardware_type
      }
      expect { @response = described_class.get_profile_ports(current_client, query_options) }.to_not raise_error
      expect(@response['ports']).not_to be_empty
    end
  end

  describe '#get_messages' do
    it 'shows messages' do
      item.retrieve!
      expect { item.get_messages }.to_not raise_error
    end
  end

  describe '#get_transformation' do
    it 'transforms an existing profile' do
      item.retrieve!
      expect { item.get_transformation('server_hardware_type' => server_hardware_type, 'enclosure_group' => enclosure_group) }
        .to_not raise_error
    end
  end

  describe '#get_compliance_preview' do
    it 'shows compliance preview' do
      item2.retrieve!
      expect { item2.get_compliance_preview }.to_not raise_error
    end
  end

  describe '#update_from_template' do
    it 'makes the Server Profile compliant with the template' do
      item2.retrieve!
      expect { @response = item2.update_from_template }.to_not raise_error
    end
  end

  describe '#get_available_networks' do
    it 'Gets available networks' do
      item2.retrieve!
      expect { @response = item2.get_available_networks }.not_to raise_error
      expect(@response['ethernetNetworks']).not_to be_empty
      expect(@response['fcNetworks']).not_to be_empty
    end
  end

  describe '#get_profile_template', if: api_version.end_with?('500') do
    it 'Gets a new profile template of a given server profile' do
      item2.retrieve!
      expect { @response = item2.get_profile_template }.not_to raise_error
      expect(@response['uri']).to be_nil
      expect(@response['name']).to be_nil
      expect(@response['enclosureGroupUri']).to eq(enclosure_group['uri'])
      expect(@response['serverHardwareTypeUri']).to eq(server_hardware_type['uri'])
    end
  end
end
