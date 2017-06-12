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

RSpec.shared_examples 'UnmanagedDeviceCreateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.new(current_client, name: UNMANAGED_DEVICE1_NAME, model: 'Unknown') }

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#add' do
    it 'Add unmanaged device' do
      expect { item.add }.to_not raise_error
      expect(item['uri']).to be
    end
  end

  describe '#environmental_configuration' do
    it 'Gets the script' do
      item.retrieve!
      expect { item.environmental_configuration }.to_not raise_error
    end
  end

  describe '#self.get_devices' do
    it 'Check if created device is present' do
      item.retrieve!
      devices = described_class.get_devices(current_client)
      expect(devices).to include(item.data)
    end
  end
end
