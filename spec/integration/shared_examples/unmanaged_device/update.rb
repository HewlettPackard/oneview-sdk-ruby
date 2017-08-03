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

RSpec.shared_examples 'UnmanagedDeviceUpdateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: interconnect_name).first }

  describe '#update' do
    it 'should change name' do
      item = described_class.find_by(current_client, name: UNMANAGED_DEVICE1_NAME).first
      item.update(name: "#{UNMANAGED_DEVICE1_NAME}_Updated")
      item.refresh
      expect(item['name']).to eq('UnmanagedDevice_1_Updated')
      item.update(name: UNMANAGED_DEVICE1_NAME)
    end
  end
end
