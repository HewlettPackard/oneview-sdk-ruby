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

RSpec.shared_examples 'ServerHardwareCreateExample' do |context_name|
  include_context context_name

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#create!' do
    it 'should throw unavailable exception' do
      item = described_class.new(current_client)
      expect { item.create! }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#add' do
    it 'can create resources' do
      options = {
        hostname: $secrets['server_hardware_ip'],
        username: $secrets['server_hardware_username'],
        password: $secrets['server_hardware_password'],
        name: 'test',
        licensingIntent: 'OneView'
      }

      item = described_class.new(current_client, options)
      expect { item.add }.to_not raise_error
      item.retrieve!
      expect(item['name']).to eq($secrets['server_hardware_ip'])
    end
  end
end
