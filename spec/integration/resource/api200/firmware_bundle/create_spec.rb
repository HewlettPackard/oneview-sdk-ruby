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

klass = OneviewSDK::FirmwareBundle
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  let(:bundle_path) { 'spec/support/hp-firmware-a1b08f8a6b-HPGH-1.1.i386.rpm' }

  describe '#self.upload' do
    it 'Upload hotfix' do
      item = OneviewSDK::FirmwareBundle.add($client, bundle_path)
      expect(item['uri']).to be
    end
  end
end
