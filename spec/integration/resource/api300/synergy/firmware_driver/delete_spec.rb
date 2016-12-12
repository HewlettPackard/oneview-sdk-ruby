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

klass = OneviewSDK::API300::Synergy::FirmwareDriver
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    it 'deletes the resource (it will fail if the applicance does not have a valid spp and hotfix)' do
      firmware = klass.new($client_300_synergy, name: FIRMWARE_DRIVER1_NAME)

      expect(firmware.retrieve!).to eq(true)
      expect { firmware.remove }.not_to raise_error
      expect(firmware.retrieve!).to eq(false)
    end

    it 'deletes other drivers' do
      klass.find_by($client_300_synergy, {}).each do |driver|
        expect { driver.remove }.not_to raise_error
        expect(driver.retrieve!).to eq(false)
      end
    end
  end
end
