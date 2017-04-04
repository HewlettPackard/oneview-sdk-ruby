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

RSpec.describe OneviewSDK::API300::C7000::Scope, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  subject(:item) { described_class.get_all($client_300).first }
  let(:enclosure) { OneviewSDK::API300::C7000::Enclosure.get_all($client_300).first }
  let(:server_hardware) { OneviewSDK::API300::C7000::ServerHardware.get_all($client_300).first }

  describe '#set_resources' do
    it 'should update the scope' do
      expect { item.set_resources(enclosure, server_hardware) }.to_not raise_error

      enclosure.refresh
      server_hardware.refresh

      expect(enclosure['scopeUris']).to match_array([item['uri']])
      expect(server_hardware['scopeUris']).to match_array([item['uri']])
    end
  end

  include_examples 'ScopeUpdateExample', 'integration api300 context'

  describe '#change_resource_assignments' do
    it 'should update the scope' do
      expect { item.change_resource_assignments(add_resources: [enclosure]) }.to_not raise_error
      enclosure.refresh
      server_hardware.refresh
      expect(enclosure['scopeUris']).to match_array([item['uri']])
      expect(server_hardware['scopeUris']).to be_empty

      expect { item.change_resource_assignments(add_resources: [server_hardware], remove_resources: [enclosure]) }.to_not raise_error
      enclosure.refresh
      server_hardware.refresh
      expect(enclosure['scopeUris']).to be_empty
      expect(server_hardware['scopeUris']).to match_array([item['uri']])

      expect { item.change_resource_assignments(remove_resources: [server_hardware]) }.to_not raise_error
      enclosure.refresh
      server_hardware.refresh
      expect(enclosure['scopeUris']).to be_empty
      expect(server_hardware['scopeUris']).to be_empty
    end
  end
end
