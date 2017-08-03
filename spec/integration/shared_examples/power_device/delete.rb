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

RSpec.shared_examples 'PowerDeviceDeleteExample' do |context_name|
  include_context context_name

  describe '#remove' do
    it 'remove Power device 1' do
      power_device_1 = described_class.new(current_client, name: POW_DEVICE1_NAME)
      power_device_1.retrieve!
      expect { power_device_1.remove }.to_not raise_error
      expect(power_device_1.retrieve!).to eq(false)
    end

    it 'remove Power device 2 [EXPECTED TO FAIL IF SCHEMATIC HAS NO IPDU]' do
      ipdu_list = described_class.find_by(current_client, 'managedBy' => { 'hostName' => current_secrets['hp_ipdu_ip'] })
      power_device_2 = ipdu_list.reject { |ipdu| ipdu['managedBy']['id'] == ipdu['id'] }.first
      expect { power_device_2.remove }.to_not raise_error
      expect(power_device_2.retrieve!).to eq(false)
    end
  end
end
