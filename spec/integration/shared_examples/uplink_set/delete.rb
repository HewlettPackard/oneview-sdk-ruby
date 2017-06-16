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

RSpec.shared_examples 'UplinkSetDeleteExample' do |context_name|
  include_context context_name

  describe '#delete' do
    it 'delete ethernet network' do
      item = described_class.find_by(current_client, name: UPLINK_SET4_NAME).first
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end

    it 'delete fc network' do
      item = described_class.find_by(current_client, name: UPLINK_SET5_NAME).first
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
