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

RSpec.describe OneviewSDK::API300::C7000::Scope do
  include_context 'shared context'

  subject(:scope) { described_class.new(@client_300, uri: '/rest/scopes/UID-111') }
  let(:fake_response) { FakeResponse.new({}) }
  let(:resource_1) { OneviewSDK::API300::C7000::ServerHardware.new(@client_300, uri: '/rest/server-hardware/UID-111') }
  let(:resource_2) { OneviewSDK::API300::C7000::ServerHardware.new(@client_300, uri: '/rest/server-hardware/UID-222') }

  it 'inherits from Resource' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Resource
  end

  it '::BASE_URI' do
    expect(described_class::BASE_URI).to eq('/rest/scopes')
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      new_item = described_class.new(@client_300)

      expect(new_item['type']).to eq('Scope')
    end
  end

  describe '#set_resources' do

    context 'when called with resources arguments' do
      it 'should work well' do
        expect(@client_300).to receive(:rest_patch).with(
          '/rest/scopes/UID-111/resource-assignments',
          'body' => {
            'addedResourceUris' => [resource_1['uri'], resource_2['uri']],
            'removedResourceUris' => []
          }
        ).and_return(fake_response)
        expect(@client_300).to receive(:response_handler).with(fake_response)

        expect(scope.set_resources(resource_1, resource_2)).to eq(scope)
      end
    end

    context 'when called with array argument' do
      it 'should work well' do
        expect(@client_300).to receive(:rest_patch).with(
          '/rest/scopes/UID-111/resource-assignments',
          'body' => {
            'addedResourceUris' => [resource_1['uri'], resource_2['uri']],
            'removedResourceUris' => []
          }
        ).and_return(fake_response)
        expect(@client_300).to receive(:response_handler).with(fake_response)

        expect(scope.set_resources([resource_1, resource_2])).to eq(scope)
      end
    end
  end

  describe '#unset_resources' do

    context 'when called with strings arguments' do
      it 'should work well' do
        expect(@client_300).to receive(:rest_patch).with(
          '/rest/scopes/UID-111/resource-assignments',
          'body' => {
            'addedResourceUris' => [],
            'removedResourceUris' => [resource_1['uri'], resource_2['uri']]
          }
        ).and_return(fake_response)
        expect(@client_300).to receive(:response_handler).with(fake_response)

        expect(scope.unset_resources(resource_1, resource_2)).to eq(scope)
      end
    end

    context 'when called with array argument' do
      it 'should work well' do
        expect(@client_300).to receive(:rest_patch).with(
          '/rest/scopes/UID-111/resource-assignments',
          'body' => {
            'addedResourceUris' => [],
            'removedResourceUris' => [resource_1['uri'], resource_2['uri']]
          }
        ).and_return(fake_response)
        expect(@client_300).to receive(:response_handler).with(fake_response)

        expect(scope.unset_resources([resource_1, resource_2])).to eq(scope)
      end
    end
  end

  describe '#change_resources_assignments' do

    context 'when called and scope has not uri' do
      let(:invalid_scope) { described_class.new(@client_300) }

      it { expect { invalid_scope.change_resources_assignments(add_resources: [resource_1]) }.to raise_error(OneviewSDK::IncompleteResource) }
      it do
        expect do
          invalid_scope.change_resources_assignments(add_resources: [resource_1])
        end.to raise_error(/Please set uri attribute before interacting with this resource/)
      end
    end

    context 'when called and resource argument has not uri' do
      let(:invalid_resource) { OneviewSDK::API300::C7000::ServerHardware.new(@client_300) }

      it { expect { scope.change_resources_assignments(add_resources: [invalid_resource]) }.to raise_error(OneviewSDK::IncompleteResource) }
      it do
        expect do
          scope.change_resources_assignments(add_resources: [invalid_resource])
        end.to raise_error(/Please set uri attribute before interacting with this resource/)
      end
    end

    context 'when called and resource has not arguments' do
      it 'should not call remote rest api' do
        expect(@client_300).to_not receive(:rest_patch)
        expect(@client_300).to_not receive(:response_handler)
        scope.change_resources_assignments
      end
    end

    it 'should work well' do
      expect(@client_300).to receive(:rest_patch).with(
        '/rest/scopes/UID-111/resource-assignments',
        'body' => {
          'addedResourceUris' => [resource_1['uri']],
          'removedResourceUris' => [resource_2['uri']]
        }
      ).and_return(fake_response)
      expect(@client_300).to receive(:response_handler).with(fake_response)

      expect(scope.change_resources_assignments(add_resources: [resource_1], remove_resources: [resource_2])).to eq(scope)
    end
  end

end
