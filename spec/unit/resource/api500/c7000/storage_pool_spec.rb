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

RSpec.describe OneviewSDK::API500::C7000::StoragePool do
  include_context 'shared context'

  let(:target) { described_class.new(@client_500) }

  it 'inherits from Resource' do
    expect(described_class).to be < OneviewSDK::API300::C7000::Resource
  end

  it 'should be correct BASE_URI' do
    expect(described_class::BASE_URI).to eq('/rest/storage-pools')
  end

  it 'should have only uri into UNIQUE_IDENTIFIERS' do
    expect(described_class::UNIQUE_IDENTIFIERS).to eq(['uri'])
  end

  it '#create' do
    expect { target.create }.to raise_error(OneviewSDK::MethodUnavailable)
  end

  it '#delete' do
    expect { target.create }.to raise_error(OneviewSDK::MethodUnavailable)
  end

  describe '::reachable' do
    it 'should call the find_with_pagination correctly' do
      expected_uri = '/rest/storage-pools/reachable-storage-pools'
      expect(described_class).to receive(:find_with_pagination).with(@client_500, expected_uri).and_return(:fake_response)
      expect(described_class.reachable(@client_500)).to eq(:fake_response)
    end

    it 'should build the URI with network URIs' do
      fc_network_class = OneviewSDK::API500::C7000::FCNetwork
      networks = [fc_network_class.new(@client_500, uri: '/uri-1'), fc_network_class.new(@client_500, uri: '/uri-2')]
      expected_uri = "/rest/storage-pools/reachable-storage-pools?networks='/uri-1,/uri-2'"
      expect(described_class).to receive(:find_with_pagination).with(@client_500, expected_uri).and_return(:fake_response)
      expect(described_class.reachable(@client_500, networks)).to eq(:fake_response)
    end
  end

  describe '#manage' do
    context 'when pass a true value' do
      it 'the isManaged attribute should be true and should call update method' do
        expect(target).to receive(:update)
        expect(target).to receive(:refresh)
        expect(target['isManaged']).not_to be
        target.manage(true)
        expect(target['isManaged']).to eq(true)
      end
    end

    context 'when pass a false value' do
      it 'the isManaged attribute should be false and should call update method' do
        expect(target).to receive(:update)
        expect(target).to receive(:refresh)
        expect(target['isManaged']).not_to be
        target.manage(false)
        expect(target['isManaged']).to eq(false)
      end
    end

    context 'when attempting to unmanage a StoreVirtual pool' do
      it 'should raise a argument error' do
        target['family'] = 'StoreVirtual'
        expect(target).not_to receive(:update)
        expect(target).not_to receive(:refresh)
        expect { target.manage(false) }.to raise_error(ArgumentError, 'Attempting to unmanage a StoreVirtual pool is not allowed')
      end
    end
  end

  describe '#request_refresh' do
    it 'should set requestingRefresh attribute to true and should call update method' do
      expect(target).to receive(:update)
      expect(target).to receive(:refresh)
      expect(target['requestingRefresh']).not_to be
      target.request_refresh
      expect(target['requestingRefresh']).to eq(true)
    end
  end

  describe '#retrieve!' do
    context 'should call super method' do
      before do
        target['uri'] = '/fake/1'
        expect(described_class).to receive(:find_by).with(@client_500, { 'uri' => '/fake/1' }, anything, anything).and_return([])
      end

      it 'when name is set but storageSystemUri is not set' do
        target['name'] = 'StoragePool'
        target.retrieve!
      end

      it 'when storageSystemUri is set but name is not set' do
        target['storageSystemUri'] = '/fake/storage-system/1'
        target.retrieve!
      end
    end

    it 'should find_by name and storageSystemUri when uri is not set' do
      target['name'] = 'StoragePool'
      target['storageSystemUri'] = '/storage-system/1'
      expect(described_class).to receive(:find_by)
        .with(@client_500, name: 'StoragePool', storageSystemUri: '/storage-system/1')
        .and_return([described_class.new(@client_500, name: 'StoragePool')])
      expect(described_class).not_to receive(:find_by).with(@client_500, { 'name' => 'StoragePool' }, anything, anything)
      expect(described_class).not_to receive(:find_by).with(@client_500, { 'uri' => '/fake/1' }, anything, anything)
      expect(target.retrieve!).to eq(true)
    end
  end

  describe '#exists?' do
    it 'should call retrieve! method with copy of current resource' do
      target['uri'] = 'fake/1'
      expect_any_instance_of(described_class).to receive(:retrieve!)
      expect(target).not_to receive(:retrieve!)
      target.exists?
    end
  end
end
