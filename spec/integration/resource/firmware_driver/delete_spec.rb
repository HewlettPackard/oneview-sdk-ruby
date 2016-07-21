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

klass = OneviewSDK::FirmwareDriver
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      firmware = OneviewSDK::FirmwareDriver.new($client, name: FIRMWARE_DRIVER1_NAME)
      firmware.retrieve!
      expect { firmware.delete }.not_to raise_error
    end

    it 'deletes other drivers' do
      OneviewSDK::FirmwareDriver.find_by($client, {}).each do |driver|
        expect { driver.delete }.not_to raise_error
      end
    end
  end
end
