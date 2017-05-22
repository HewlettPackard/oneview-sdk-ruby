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

RSpec.shared_examples 'InterconnectCreateExample' do |context_name, greater_than_or_equal_500|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: interconnect_name).first }

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end

  describe '#name_servers' do
    it 'retrieves name servers' do
      expect { item.name_servers }.not_to raise_error
    end
  end

  describe '#statistics' do
    it 'gets statistics' do
      expect { item.statistics }.not_to raise_error
    end

    it 'gets statistics for a specific port' do
      port = item[:ports].first
      expect { item.statistics(port['name']) }.not_to raise_error
    end
  end

  describe '#get_types' do
    it 'retrieves interconnect types' do
      expect { described_class.get_types(current_client) }.not_to raise_error
    end
  end

  describe '#get_type' do
    it 'retrieves the interconnect type with name' do
      interconnect_type_found = {}
      expect { interconnect_type_found = described_class.get_type(current_client, interconnect_type) }.not_to raise_error
      expect(interconnect_type_found['name']).to eq(interconnect_type)
    end
  end

  describe '#get_pluggable_module_information', if: greater_than_or_equal_500 do
    it 'Gets all the Small Form-factor Pluggable (SFP) instances of the interconnect' do
      expect { item.get_pluggable_module_information }.not_to raise_error
    end
  end
end
