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

RSpec.shared_examples 'ServerHardwareTypeCreateExample' do |context_name, is_c7000|
  include_context context_name

  describe '#create' do
    it 'should throw unavailable exception' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  context 'when create server hardware', if: is_c7000 do
    it 'should create server hardware type' do
      options = {
        hostname: $secrets['server_hardware2_ip'],
        username: $secrets['server_hardware2_username'],
        password: $secrets['server_hardware2_password'],
        name: 'Server Hardware Type OneViewSDK Test',
        licensingIntent: 'OneView'
      }

      server_hardware = server_hardware_class.new(current_client, options)

      expect { server_hardware.add }.to_not raise_error

      item = described_class.new(current_client, uri: server_hardware['serverHardwareTypeUri'])

      expect(item.retrieve!).to eq(true)
    end
  end
end
