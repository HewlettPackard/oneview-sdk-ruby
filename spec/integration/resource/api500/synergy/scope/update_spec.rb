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

RSpec.describe OneviewSDK::API500::Synergy::Scope, integration: true, type: UPDATE do
  include_context 'integration api500 context'

  subject(:item) { described_class.get_all($client_500_synergy).first }
  subject(:enclosure) { OneviewSDK::API500::Synergy::Enclosure.get_all($client_500_synergy).first }
  subject(:server_hardware) { OneviewSDK::API500::Synergy::ServerHardware.get_all($client_500_synergy).first }

  describe '#set_resources' do
    it 'should raise an exception when resource is not found' do
      encl = OneviewSDK::API500::Synergy::Enclosure.new($client_500_synergy, name: 'Any')
      expect { item.set_resources(encl) }.to raise_error(OneviewSDK::NotFound, /The resource was not found/)
    end

    it 'should update the scope' do
      expect { item.set_resources(enclosure) }.to_not raise_error
      expect { item.set_resources(server_hardware) }.to_not raise_error

      enclosure.refresh
      server_hardware.refresh

      expect(enclosure['scopeUris']).to match_array([item['uri']])
      expect(server_hardware['scopeUris']).to match_array([item['uri']])
    end
  end

  include_examples 'ScopeUpdateExample', 'integration api500 context'

  describe '#patch' do
    it 'raises exception when uri is empty' do
      item = described_class.new($client_500_synergy)
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

  describe '#change_resource_assignments' do
    it 'should update the scope' do
      expect { item.change_resource_assignments(add_resources: [enclosure]) }
        .to raise_error(OneviewSDK::MethodUnavailable, /method #change_resource_assignments is unavailable/)
    end
  end
end
