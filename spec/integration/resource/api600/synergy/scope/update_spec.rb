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

RSpec.describe OneviewSDK::API600::C7000::Scope, integration: true, type: UPDATE do
  include_context 'integration api600 context'

  subject(:item) { described_class.get_all($client_600).first }
  subject(:enclosure) { OneviewSDK::API600::C7000::Enclosure.get_all($client_600).first }
  subject(:server_hardware) { OneviewSDK::API600::C7000::ServerHardware.get_all($client_600).first }

  include_examples 'ScopeUpdateExample', 'integration api600 context'

  describe '::replace_resource_assigned_scope' do
    it 'should replace the resource scope' do
      options = {
        name: 'new scope',
        description: 'Sample Scope description'
      }
      scope = described_class.new($client_600, options)
      scope.create
      new_scopes = [scope['uri']]
      old_scopes = described_class.get_resource_scopes($client_600, server_hardware)
      expect { described_class.replace_resource_assigned_scopes($client_600, server_hardware, scopes: new_scopes) }.to_not raise_error
      server_hardware.refresh
      updated_resource_scopes = described_class.get_resource_scopes($client_600, server_hardware)['scopeUris']
      expect(new_scopes).to match_array(updated_resource_scopes)

      # Update the resource with old scopes
      described_class.replace_resource_assigned_scopes($client_600, server_hardware, old_scopes)
      current_scopes = described_class.get_resource_scopes($client_600, server_hardware)
      expect(current_scopes).to match_array(old_scopes)
    end
  end

  describe '::resource_patch' do
    it 'should update the scope of resource' do
      options = {
        name: 'test scope',
        description: 'Sample Scope description'
      }
      scope = described_class.new($client_600, options)
      scope.create
      old_scopes = described_class.get_resource_scopes($client_600, server_hardware)
      expect { described_class.resource_patch($client_600, server_hardware, add_scopes: [scope], remove_scopes: [item]) }.to_not raise_error
      new_scopes = described_class.get_resource_scopes($client_600, server_hardware)['scopeUris']
      expect(new_scopes).to include(scope['uri'])

      # scope_index = new_scopes.find_index { |uri| uri == scope['uri'] }
      expect { described_class.resource_patch($client_600, server_hardware, add_scopes: [item], remove_scopes: [scope]) }.to_not raise_error
      new_scopes = described_class.get_resource_scopes($client_600, server_hardware)
      expect(old_scopes).to match_array(new_scopes)
    end
  end
end
