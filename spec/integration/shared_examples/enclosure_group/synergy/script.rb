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

RSpec.shared_examples 'EnclGroupScriptSynergyExample' do |context_name, version|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: ENC_GROUP_NAME).first }

  describe '#set_script' do
    it 'returns method unavailable for the set_script method' do
      expect { item.set_script }.to raise_error(/The method #set_script is unavailable for this resource/)
    end
  end

  describe '#get_script' do
    it 'can retrieve the script', if: version < 500 do
      script = item.get_script
      expect(script.tr('"', '')).to be_a(String)
    end

    it 'returns method unavailable for the get_script method', if: version >= 500 do
      expect { item.get_script }.to raise_error(/The method #get_script is unavailable for this resource/)
    end
  end
end
