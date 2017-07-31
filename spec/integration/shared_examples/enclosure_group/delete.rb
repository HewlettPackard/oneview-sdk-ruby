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

RSpec.shared_examples 'EnclosureGroupDeleteExample' do |context_name, execute_with_enclosure_index|
  include_context context_name

  describe '#delete' do
    it 'deletes the simple enclosure group' do
      item = described_class.find_by(current_client, 'name' => ENC_GROUP_NAME).first
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end

    it 'deletes the enclosure group with LIG' do
      item = described_class.find_by(current_client, 'name' => ENC_GROUP2_NAME).first
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end

    it 'deletes the enclosure group with LIG on enclosure index specific', if: execute_with_enclosure_index do
      item = described_class.find_by(current_client, 'name' => ENC_GROUP3_NAME).first
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
