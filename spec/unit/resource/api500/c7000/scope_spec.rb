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

  describe '#set_resources' do
    context 'when called with resources arguments' do
      it 'should work well' do
        body = [{
          'op' => 'add',
          'path' => '/addedResourceUris/-',
          'value' => resource_1['uri']
        }]
        data = { 'Content-Type' => 'application/json-patch+json', 'body' => body }

        expect(@client_500).to receive(:rest_patch).with('/rest/scopes/UID-111', data, scope.api_version).and_return(fake_response)
        expect(@client_500).to receive(:response_handler).with(fake_response).and_return('fake')
        expect(scope.set_resources(resource_1)).to eq('fake')
      end
    end
  end

  describe '#unset_resources' do
    before :each do
      body = [{
        'op' => 'replace',
        'path' => '/removedResourceUris',
        'value' => [resource_1['uri'], resource_2['uri']]
      }]
      data = { 'Content-Type' => 'application/json-patch+json', 'body' => body }
      expect(@client_500).to receive(:rest_patch).with('/rest/scopes/UID-111', data, scope.api_version).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('fake')
    end

    context 'when called with strings arguments' do
      it 'should work well' do
        expect(scope.unset_resources(resource_1, resource_2)).to eq('fake')
      end
    end

    context 'when called with array argument' do
      it 'should work well' do
        expect(scope.unset_resources([resource_1, resource_2])).to eq('fake')
      end
    end
  end

  describe '#change_resource_assignments' do
    it 'method is unavailable' do
      expect { scope.change_resource_assignments }.to raise_error(OneviewSDK::MethodUnavailable, /method #change_resource_assignments is unavailable/)
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
