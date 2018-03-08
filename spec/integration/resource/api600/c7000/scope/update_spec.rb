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

require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::Scope, integration: true, type: UPDATE do
  include_context 'integration api500 context'

  subject(:item) { described_class.get_all($client_500).first }
  subject(:enclosure) { OneviewSDK::API500::C7000::Enclosure.get_all($client_500).first }
  subject(:server_hardware) { OneviewSDK::API500::C7000::ServerHardware.get_all($client_500).first }

  include_examples 'ScopeUpdateExample', 'integration api500 context'

  describe '#patch' do
    it 'raises exception when uri is empty' do
      item = described_class.new($client_500)
      expect { item.patch('replace', '/name', 'New_Name') }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'should update the scope name' do
      old_name = item['name']
      expect { item.patch('replace', '/name', "#{old_name} Updated") }.to_not raise_error

      item.refresh
      expect(item['name']).to eq("#{old_name} Updated")

      # coming back to original name
      item['name'] = old_name
      expect { item.patch('replace', '/name', old_name) }.to_not raise_error
      expect(item['name']).to eq(old_name)
    end
  end
end
