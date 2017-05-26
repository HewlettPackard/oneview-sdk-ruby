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

RSpec.shared_examples 'EnclosureGroupUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'updates an enclosure group' do
      new_name = "#{ENC_GROUP_NAME}_Updated"
      item = described_class.find_by(current_client, name: ENC_GROUP_NAME).first
      item['name'] = new_name
      item.update
      expect(item['name']).to eq(new_name)
      item['name'] = ENC_GROUP_NAME
      item.update
      expect(item['name']).to eq(ENC_GROUP_NAME)
    end
  end
end
