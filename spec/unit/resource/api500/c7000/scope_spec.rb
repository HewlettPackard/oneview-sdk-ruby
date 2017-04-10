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

RSpec.describe OneviewSDK::API500::C7000::Scope do
  include_context 'shared context'

  subject(:scope) { described_class.new(@client_500, uri: '/rest/scopes/UID-111') }
  let(:fake_response) { FakeResponse.new({}) }
  let(:resource_1) { OneviewSDK::API500::C7000::ServerHardware.new(@client_500, uri: '/rest/server-hardware/UID-111') }
  let(:resource_2) { OneviewSDK::API500::C7000::ServerHardware.new(@client_500, uri: '/rest/server-hardware/UID-222') }

  it 'inherits from API 300' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Scope
  end

  it '::BASE_URI' do
    expect(described_class::BASE_URI).to eq('/rest/scopes')
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      new_item = described_class.new(@client_500)

      expect(new_item['type']).to eq('ScopeV2')
    end
  end

  describe '#change_resource_assignments' do

    context 'when called and scope has no URI' do
      let(:invalid_scope) { described_class.new(@client_500) }

      it { expect { invalid_scope.change_resource_assignments(add_resources: [resource_1]) }.to raise_error(OneviewSDK::IncompleteResource) }
      it do
        expect do
          invalid_scope.change_resource_assignments(add_resources: [resource_1])
        end.to raise_error(/Please set uri attribute before interacting with this resource/)
      end
    end

    context 'when called and resource argument has no URI' do
      let(:invalid_resource) { OneviewSDK::API500::C7000::ServerHardware.new(@client_500) }

      it { expect { scope.change_resource_assignments(add_resources: [invalid_resource]) }.to raise_error(OneviewSDK::IncompleteResource) }
      it do
        expect do
          scope.change_resource_assignments(add_resources: [invalid_resource])
        end.to raise_error(/Please set uri attribute before interacting with this resource/)
      end
    end

    context 'when called and resource has not arguments' do
      it 'should not call remote rest api' do
        expect(@client_500).to_not receive(:rest_patch)
        expect(@client_500).to_not receive(:response_handler)
        scope.change_resource_assignments
      end
    end

    it 'should work well' do
      body = [
        { 'op' => 'add', 'path' => '/addedResourceUris/-', 'value' => resource_1['uri'] },
        { 'op' => 'replace', 'path' => '/removedResourceUris', 'value' => [resource_2['uri']] }
      ]

      data = { 'Content-Type' => 'application/json-patch+json', 'body' => body }
      expect(@client_500).to receive(:rest_patch).with('/rest/scopes/UID-111', data, scope.api_version).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response)

      expect(scope.change_resource_assignments(add_resources: [resource_1], remove_resources: [resource_2])).to eq(scope)
    end
  end

  describe '#patch' do
    it 'performs the patch successfully' do
      body = [{
        'op' => 'replace',
        'path' => '/name',
        'value' => 'New_Name'
      }]
      data = { 'Content-Type' => 'application/json-patch+json', 'body' => body }
      expect(@client_500).to receive(:rest_patch).with('/rest/scopes/UID-111', data, scope.api_version).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('fake')
      expect(scope.patch('replace', '/name', 'New_Name')).to eq('fake')
    end
  end
end
