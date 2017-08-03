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

RSpec.shared_examples 'EnclGroupScriptC7000Example' do |context_name|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: ENC_GROUP_NAME).first }
  let(:command) { '#TEST COMMAND' }

  describe '#set_script' do
    it 'can set the script' do
      item.set_script(command)
      expect(item.get_script.tr('"', '')).to eq(command)
    end
  end

  describe '#get_script' do
    it 'can retrieve the script' do
      script = item.get_script
      expect(script.tr('"', '')).to eq(command)
    end
  end
end
