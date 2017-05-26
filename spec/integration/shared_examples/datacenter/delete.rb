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

RSpec.shared_examples 'DatacenterDeleteExample' do |context_name|
  include_context context_name

  subject(:item1) { described_class.find_by(current_client, name: DATACENTER1_NAME).first }
  subject(:item2) { described_class.find_by(current_client, name: DATACENTER2_NAME).first }
  subject(:item3) { described_class.find_by(current_client, name: DATACENTER3_NAME).first }

  describe '#delete' do
    it 'self raises MethodUnavailable' do
      expect { item1.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#remove' do
    it 'removes the resource' do
      item1.remove
      expect(item1.retrieve!).to eq(false)
      item2.remove
      expect(item2.retrieve!).to eq(false)
      item3.remove
      expect(item3.retrieve!).to eq(false)
    end
  end
end
