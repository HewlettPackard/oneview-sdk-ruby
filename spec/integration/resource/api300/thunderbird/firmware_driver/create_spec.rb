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
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'Create custom spp (it will fail if the applicance does not have a valid spp and hotfix)' do
      spp = klass.find_by($client_300_synergy, state: 'Created', bundleType: 'SPP').first
      hotfix = klass.find_by($client_300_synergy, state: 'Created', bundleType: 'Hotfix').first
      expect(spp['uri']).to be
      expect(hotfix['uri']).to be
      custom = klass.new($client_300_synergy)
      custom['baselineUri'] = spp['uri']
      custom['hotfixUris'] = [
        hotfix['uri']
      ]
      custom['customBaselineName'] = FIRMWARE_DRIVER1_NAME

      expect { custom.create }.not_to raise_error
      expect(custom['uri']).to include(FIRMWARE_DRIVER1_NAME)
    end
  end

end
