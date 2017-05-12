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

RSpec.shared_examples 'SwitchCreateExample' do |context_name, only_c7000|
  include_context context_name

  describe '#create', if: only_c7000 do
    it 'raises MethodUnavailable' do
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#statistics', if: only_c7000 do
    it 'gets data for switch' do
      expect(item.statistics).to_not be_empty
    end

    it 'gets data for the port X1. FAIL: May be a bug in OneView. Failure reported to the oneview team' do
      expect(item.statistics('1.1')).to_not be_empty
    end
  end

  describe '#environmentalConfiguration', if: only_c7000 do
    it 'gets the current environmental configuration' do
      expect(item.environmental_configuration).to_not be_empty
    end
  end

  describe '#get_types' do
    it 'list all the types' do
      expect(described_class.get_types(current_client)).to_not be_empty
    end

    it 'get one desired type' do
      model_name = 'Cisco Nexus 55xx'
      model = described_class.get_type(current_client, model_name)
      expect(model).to_not be_empty
      expect(model['name']).to eq(model_name)
      expect(model['uri']).to_not be_empty
    end
  end
end
