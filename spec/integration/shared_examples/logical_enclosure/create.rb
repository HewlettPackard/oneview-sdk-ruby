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

RSpec.shared_examples 'LogicalEnclosureCreateExample' do |context_name, variant|
  include_context context_name

  describe '#create' do

    it 'raises MethodUnavailable', if: variant == 'C7000' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end

    it 'create a logical enclosure', if: variant == 'Synergy' do
      enclosure_group = encl_group_class.find_by(current_client, name: ENC_GROUP2_NAME).first
      enclosure1 = enclosure_class.find_by(current_client, uuid: ENCL1_UUID).first
      enclosure2 = enclosure_class.find_by(current_client, uuid: ENCL2_UUID).first
      enclosure3 = enclosure_class.find_by(current_client, uuid: ENCL3_UUID).first

      item = described_class.new(current_client, name: LOG_ENCL1_NAME, forceInstallFirmware: false, firmwareBaselineUri: nil)
      item.set_enclosure_group(enclosure_group)
      item.set_enclosures([enclosure1, enclosure2, enclosure3])

      expect { item.create }.to_not raise_error

      result = described_class.find_by(current_client, name: LOG_ENCL1_NAME).first
      expect(result['uri']).to be_truthy
      expect(result['enclosureGroupUri']).to eq(item['enclosureGroupUri'])
      expect(result['enclosureUris']).to eq(item['enclosureUris'])
      expect(result['enclosures'].size).to eq(3)
      expect(result['enclosures'].key?(item['enclosureUris'].first)).to be true
    end
  end
end
