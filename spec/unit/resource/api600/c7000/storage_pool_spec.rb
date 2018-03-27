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

RSpec.describe OneviewSDK::API600::C7000::StoragePool do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::StoragePool' do
    expect(described_class).to be < OneviewSDK::API500::C7000::StoragePool
  end

  it 'should be correct BASE_URI' do
    expect(described_class::BASE_URI).to eq('/rest/storage-pools')
  end

  describe '::reachable' do
    it 'should call the find_with_pagination correctly' do
      expected_uri = '/rest/storage-pools/reachable-storage-pools'
      expect(described_class).to receive(:find_with_pagination).with(@client_600, expected_uri).and_return(:fake_response)
      expect(described_class.reachable(@client_600)).to eq(:fake_response)
    end

    it 'should build the URI with query' do
      query = { networks: ['/uri-1', '/uri-2'], scopeExclusions: ['/uri-1', '/uri-2'], scopeUris: ['/uri-1', '/uri-2'] }
      expected_uri = "/rest/storage-pools/reachable-storage-pools?networks='/uri-1,/uri-2'&scopeexclusions='/uri-1,/uri-2'&scopeuris='/uri-1,/uri-2'"
      expect(described_class).to receive(:find_with_pagination).with(@client_600, expected_uri).and_return(:fake_response)
      expect(described_class.reachable(@client_600, query)).to eq(:fake_response)
    end
  end
end
