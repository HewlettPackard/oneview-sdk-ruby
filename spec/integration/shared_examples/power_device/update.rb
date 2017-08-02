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

RSpec.shared_examples 'PowerDeviceUpdateExample' do |context_name|
  include_context context_name

  let(:ipdu_list) { described_class.find_by(current_client, 'managedBy' => { 'hostName' => current_secrets['hp_ipdu_ip'] }) }
  let(:item) { ipdu_list.reject { |ipdu| ipdu['managedBy']['id'] == ipdu['id'] }.first }

  describe '#update' do
    it 'Change name' do
      power_device = described_class.new(current_client, name: POW_DEVICE1_NAME)
      expect(power_device.retrieve!).to eq(true)
      old_name = power_device['name']
      power_device.update(name: 'PowerDevice_Name_Updated')
      power_device.refresh
      expect(power_device['name']).to eq('PowerDevice_Name_Updated')
      power_device.update(name: old_name)
      power_device.refresh
      expect(power_device['name']).to eq(old_name)
    end
  end

  describe '#set_refresh_state [EXPECTED TO FAIL IF SCHEMATIC HAS NO IPDU]' do
    it 'Refresh without changing credentials' do
      expect { item.set_refresh_state(refreshState: 'RefreshPending') }.not_to raise_error
      item.refresh
      expect(item['state']).to eq('Configured')
    end

    it 'Refresh with new credentials' do
      options = {
        refreshState: 'RefreshPending',
        username: current_secrets['hp_ipdu_username'],
        password: current_secrets['hp_ipdu_password']
      }
      expect { item.set_refresh_state(options) }.not_to raise_error
    end
  end

  describe '#set_power_state [EXPECTED TO FAIL IF SCHEMATIC HAS NO IPDU]' do
    it 'On|off state on a device that supports this operation' do
      power_device = ipdu_list.reject { |ipdu| ipdu['model'] != 'Managed Ext. Bar Outlet' }.first
      original_value, new_value = power_device.get_power_state == '"On"' ? %w(On Off) : %w(Off On)

      expect { power_device.set_power_state(new_value) }.not_to raise_error
      expect(power_device.get_power_state).to eq("\"#{new_value}\"")

      # back to the original value
      expect { power_device.set_power_state(original_value) }.not_to raise_error
      expect(power_device.get_power_state).to eq("\"#{original_value}\"")
    end
  end

  describe '#set_uid_state [EXPECTED TO FAIL IF SCHEMATIC HAS NO IPDU]' do
    it 'On|off' do
      original_value, new_value = item.get_uid_state == '"On"' ? %w(On Off) : %w(Off On)

      expect { item.set_uid_state(new_value) }.not_to raise_error
      expect(item.get_uid_state).to eq("\"#{new_value}\"")

      # back to the original value
      expect { item.set_uid_state(original_value) }.not_to raise_error
      expect(item.get_uid_state).to eq("\"#{original_value}\"")
    end
  end
end
