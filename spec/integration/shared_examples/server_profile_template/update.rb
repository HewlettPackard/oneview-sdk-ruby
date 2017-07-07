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

RSpec.shared_examples 'ServerProfileTemplateUpdateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: SERVER_PROFILE_TEMPLATE_NAME).first }
  let(:item2) { described_class.new(current_client, name: 'template') }
  let(:server_hardware_type) { resource_class_of('ServerHardwareType').find_by(current_client, {}).first }
  let(:enclosure_group) { resource_class_of('EnclosureGroup').find_by(current_client, {}).first }
  api_version = described_class.to_s.split('::')[1]

  describe '#update' do
    it 'updates the name attribute' do
      expect { item.update(name: "#{SERVER_PROFILE_TEMPLATE_NAME}_Updated") }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq("#{SERVER_PROFILE_TEMPLATE_NAME}_Updated")
      expect { item.update(name: SERVER_PROFILE_TEMPLATE_NAME) }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(SERVER_PROFILE_TEMPLATE_NAME)
    end
  end

  describe '#get_available_hardware' do
    it 'raises an exception when serverHardwareTypeUri is missing' do
      item2.set_enclosure_group(enclosure_group)
      expect { item2.get_available_hardware }.to raise_error(/Failed to get available hardware/)
    end

    it 'raises an exception when enclosureGroupUri is missing' do
      item2.set_server_hardware_type(server_hardware_type)
      expect { item2.get_available_hardware }.to raise_error(/Failed to get available hardware/)
    end

    it 'getting the the available server hardwares' do
      item2.set_server_hardware_type(server_hardware_type)
      item2.set_enclosure_group(enclosure_group)
      expect { item2.get_available_hardware }.to_not raise_error
    end
  end

  describe '#get_transformation', if: api_version.end_with?('300', '500') do
    it 'transforms an existing profile' do
      server_hardware_type = resource_class_of('ServerHardwareType').find_by(current_client, {}).first
      enclosure_group = resource_class_of('EnclosureGroup').find_by(current_client, {}).first
      options = { 'server_hardware_type' => server_hardware_type, 'enclosure_group' => enclosure_group }
      expect { item.get_transformation(current_client, options) }.to_not raise_error
    end
  end
end
