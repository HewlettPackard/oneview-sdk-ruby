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

  describe '#replace_resource_assigned_scope' do
    it 'should replace the resource scope' do
      old_scopes = described_class.get_resource_scopes(server_hardware)
      options = {
        name: 'Scope test',
        description: 'Sample Scope description'
      }
      new_scope = described_class.new(@client, options)
      new_scope.create
      new_resource_scopes = [new_scope['uri']]
      expect { described.replace_resource_assigned_scopes(server_hardware, new_resource_scopes) }.to_not raise_error

      updated_resource_scopes = described_class.get_resource_scopes(server_hardware)
      expect(old_scopes).to_not eq(updated_resource_scopes)

      # Update the resource with old scopes and delete newly created scope
      described_class.replace_resource_assigned_scopes(server_hardware, old_scopes)
      current_scopes = described_class.get_resource_scopes(server_hardware)
      expect(current_scopes).to eq(old_scopes)
      new_scope.delete
    end
  end

  describe '#resource_patch' do
    it 'should update the scope of resource' do
      old_scopes = described_class.get_resource_scopes(server_hardware)
      options = {
        name: 'Scope test',
        description: 'Sample Scope description'
      }
      new_scope = described_class.new(@client, options)
      new_scope.create
      expect { described_class.resource_patch(server_hardware['scopesUri'], 'add', '/scopeUris/-', new_scope['uri']) }.to_not raise_error
      new_scopes = described_class.get_resource_scopes(server_hardware)
      expect(old_scopes).to_not eq(new_scopes)

      scope_index = new_scopes.find_index { |uri| uri == new_scope['uri'] }
      expect { described_class.resource_patch(server_hardware['scopesUri'], 'remove', "/scopeUris/#{scope_index}") }.to_not raise_error
      new_scopes = described_class.get_resource_scopes(server_hardware)
      expect(old_scopes).to eq(new_scopes)
      new_scope.delete
    end
  end
end
