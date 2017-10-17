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

RSpec.shared_examples 'SwitchUpdateExample  API300' do |context_name|
  include_context context_name
  let(:switch) do
    described_class.get_all(current_client).find do |resource|
      !resource['ports'].select { |k| k['portStatus'] == 'Unlinked' }.empty?
    end
  end

  describe '#update_port' do
    it 'updates with valid attributes [it will fail if the appliance does not have some switch with unlinked ports]' do
      port = switch['ports'].select { |k| k['portStatus'] == 'Unlinked' }.first
      old_enabled = port['enabled']
      expect { switch.update_port(port['name'], enabled: !old_enabled) }.not_to raise_error
      sleep(30)
      switch.retrieve!
      port_updated = switch['ports'].select { |k| k['portName'] == port['name'] }.first
      expect(port_updated['enabled']).to eq(!old_enabled)
      uplink = resource_class_of('EthernetNetwork').find_by(current_client, name: ETH_NET_NAME).first
      expect { switch.update_port(port['name'], enabled: old_enabled, associatedUplinkSetUri: uplink['uri']) }.not_to raise_error
      sleep(30)
      switch.retrieve!
      port_updated = switch['ports'].select { |k| k['portName'] == port['name'] }.first
      expect(port_updated['enabled']).to eq(old_enabled)
    end
  end
end
