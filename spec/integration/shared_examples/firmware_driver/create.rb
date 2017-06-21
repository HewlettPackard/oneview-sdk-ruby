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

RSpec.shared_examples 'FirmwareDriverCreateExample' do |context_name|
  include_context context_name

  describe '#create' do
    it 'Create custom spp' do
      spp = described_class.find_by(current_client, state: 'Created', bundleType: 'SPP').first
      hotfix = described_class.find_by(current_client, state: 'Created', bundleType: 'Hotfix').first
      expect(spp['uri']).to be
      expect(hotfix['uri']).to be
      custom = described_class.new(current_client)
      custom['baselineUri'] = spp['uri']
      custom['hotfixUris'] = [
        hotfix['uri']
      ]
      custom['customBaselineName'] = FIRMWARE_DRIVER1_NAME
      expect { custom.create }.not_to raise_error
      expect(custom['uri']).to be
    end
  end


end
