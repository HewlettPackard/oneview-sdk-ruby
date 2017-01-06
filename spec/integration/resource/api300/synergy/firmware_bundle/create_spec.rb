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

klass = OneviewSDK::API300::Synergy::FirmwareBundle
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:hotfix_path) { 'spec/support/hp-firmware-a1b08f8a6b-HPGH-1.1.i386.rpm' }
  let(:spp_path) { 'spec/support/custom-spp-synergy.iso' }

  describe '#self.upload' do
    it 'Upload hotfix' do
      item = klass.add($client_300_synergy, hotfix_path)
      expect(item['uri']).to be
      expect(item['bundleType']).to eq('Hotfix')
    end

    it 'Upload SPP' do
      item = klass.add($client_300_synergy, spp_path)
      expect(item['uri']).to be
      expect(item['bundleType']).to eq('SPP')
    end
  end
end
