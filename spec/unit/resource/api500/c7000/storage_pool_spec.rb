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

  it '#create' do
    expect { target.create }.to raise_error(OneviewSDK::MethodUnavailable)
  end

  it '#delete' do
    expect { target.create }.to raise_error(OneviewSDK::MethodUnavailable)
  end

  it '::reachable' do
    expected_uri = '/rest/storage-pools/reachable-storage-pools'
    expect(@client_500).to receive(:find_with_pagination).with(expected_uri, {}).and_return(:fake_response)
    expect(described_class.reachable(@client_500)).to eq(:fake_response)
  end

  describe '#manage' do
    context 'when pass a true value' do
      it 'the isManaged attribute should be true and should call update method' do
        expect(target).to receive(:update)
        expect(target['isManaged']).not_to be
        target.manage(true)
        expect(target['isManaged']).to eq(true)
      end
    end

    context 'when pass a false value' do
      it 'the isManaged attribute should be false and should call update method' do
        expect(target).to receive(:update)
        expect(target['isManaged']).not_to be
        target.manage(false)
        expect(target['isManaged']).to eq(false)
      end
    end
  end

  describe '#request_refresh' do
    it 'should set requestingRefresh attribute to true and should call update method' do
      expect(target).to receive(:update)
      expect(target['requestingRefresh']).not_to be
      target.request_refresh
      expect(target['requestingRefresh']).to eq(true)
    end
  end
end
