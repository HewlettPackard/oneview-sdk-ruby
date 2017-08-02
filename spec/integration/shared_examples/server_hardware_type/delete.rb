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

RSpec.shared_examples 'ServerHardwareTypeDeleteExample' do |context_name, is_c7000|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, uri: server_hardware['serverHardwareTypeUri']).first }

  describe '#delete' do
    it 'should throw unavailable exception' do
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#remove' do
    context 'when matches server hardware that is under management' do
      it 'should not remove the resource' do
        expect { item.remove }.to raise_error(OneviewSDK::TaskError)
        expect(item.retrieve!).to eq(true)
      end
    end

    context 'when no matches server hardware', if: is_c7000 do
      it 'should remove the resource' do
        expect { server_hardware.remove }.not_to raise_error
        expect { item.remove }.not_to raise_error
        expect(item.retrieve!).to eq(false)
      end
    end
  end
end
