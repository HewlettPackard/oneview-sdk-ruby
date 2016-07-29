# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::Rack
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#add' do
    it 'Add empty rack' do
      item = OneviewSDK::Rack.new($client, name: RACK1_NAME)
      item.add
      expect(item['name']).to eq(RACK1_NAME)
      expect(item['uri']).not_to be_empty
    end

    it 'Add rack with custom size and mounted enclosure' do
      server_hardware = OneviewSDK::ServerHardware.new($client, name: $secrets['rack_server_hardware_ip'])
      server_hardware.retrieve!

      item = OneviewSDK::Rack.new($client, name: RACK2_NAME)
      item['depth'] = 1500
      item['width'] = 1200
      item['height'] = 2500

      item.add_rack_resource(server_hardware, topUSlot: 20, uHeight: 10)
      item.add

      expect(item['uri']).not_to be_empty
      expect(item['depth']).to eq(1500)
      expect(item['width']).to eq(1200)
      expect(item['height']).to eq(2500)

      server_hardware_mount = item['rackMounts'].find { |resource_from_rack| resource_from_rack['mountUri'] == server_hardware['uri'] }
      expect(server_hardware_mount['mountUri']).to eq(server_hardware['uri'])
      expect(server_hardware_mount['topUSlot']).to eq(20)
      expect(server_hardware_mount['uHeight']).to eq(10)
    end
  end

  describe '#get_device_topology' do
    it 'Retrieve device topology' do
      item = OneviewSDK::Rack.new($client, name: RACK2_NAME)
      item.retrieve!
      expect { item.get_device_topology }.not_to raise_error
    end
  end
end
