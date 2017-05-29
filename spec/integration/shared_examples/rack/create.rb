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

RSpec.shared_examples 'RackCreateExample' do |context_name|
  include_context context_name

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#add' do
    it 'Add empty rack' do
      item = described_class.new(current_client, name: RACK1_NAME)
      item.add
      expect(item['name']).to eq(RACK1_NAME)
      expect(item['uri']).not_to be_empty
    end
  end

  describe '#get_device_topology' do
    it 'Retrieve device topology' do
      item = described_class.new(current_client, name: RACK1_NAME)
      item.retrieve!
      expect { item.get_device_topology }.not_to raise_error
    end
  end
end
