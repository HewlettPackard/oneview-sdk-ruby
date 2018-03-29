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

RSpec.describe OneviewSDK::API600::C7000::Scope do
  include_context 'shared context'

  subject(:scope) { described_class.new(@client_600, uri: '/rest/scopes/UID-111') }
  let(:scope1) { described_class.new(@client_600, uri: '/rest/scopes/UID-222') }
  let(:fake_response) { FakeResponse.new({}) }
  let(:resource_1) do
    OneviewSDK::API600::C7000::ServerHardware.new(@client_600, uri: '/rest/server-hardware/UID-111',
                                                               scopesUri: '/rest/scope/resources/rest/server-hardware/UID-111',
                                                               scopeUris: ['/rest/scope/fake1', 'resr/scope/fake2'])
  end
  let(:resource_2) { OneviewSDK::API600::C7000::ServerHardware.new(@client_600, uri: '/rest/server-hardware/UID-222') }

  it 'inherits from API 500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::Scope
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      new_item = described_class.new(@client_600)
      expect(new_item['type']).to eq('ScopeV3')
    end
  end

  describe '#get_resource_scope' do
    it 'returns the response body from rest/scope/resources/*' do
      expect(@client_600).to receive(:rest_get).with('/rest/scope/resources/rest/server-hardware/UID-111')
                                               .and_return(fake_response)
      expect(scope.get_resource_scopes(resource_1)).to eq({})
    end
  end

  describe '#replace_resource_assigned_scopes' do
    it 'performs replace successfully' do
      options = { 'Content-Type' => 'application/json-patch+json',
                  'If-Match' => '*',
                  'body' => { 'type' => 'ScopedResource',
                              'resourceUri' => '/rest/server-hardware/UID-111',
                              'scopeUris' => ['/rest/scopes/UID-222'] } }
      expect(@client_600).to receive(:rest_put).with('/rest/scope/resources/rest/server-hardware/UID-111', options).and_return(fake_response)
      expect(@client_600).to receive(:response_handler).with(fake_response).and_return('fake')
      expect(scope.replace_resource_assigned_scopes(resource_1, scopes: [scope1])).to eq('fake')
    end
  end

  describe '#resource_patch' do
    it 'performs the patch successfully' do
      body = [{
        'op' => 'add',
        'path' => '/scopeUris/-',
        'value' => '/rest/scope/id'
      }]
      data = { 'Content-Type' => 'application/json-patch+json', 'If-Match' => '*', 'body' => body }
      expect(@client_600).to receive(:rest_patch).with('/rest/scopes/resources/', data, scope.api_version).and_return(fake_response)
      expect(@client_600).to receive(:response_handler).with(fake_response).and_return('fake')
      expect(scope.resource_patch('/rest/scopes/resources/', 'add', '/scopeUris/-', '/rest/scope/id')).to eq('fake')
    end
  end
end
