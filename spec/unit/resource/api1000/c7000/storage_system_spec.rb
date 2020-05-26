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

RSpec.describe OneviewSDK::API1000::C7000::StorageSystem do
  include_context 'shared context'

  let(:client) { @client_1000 }

  it 'inherits from OneviewSDK::API800::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API800::C7000::StorageSystem
  end

  describe '#update' do
    it 'should call correct uri' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      fake_response = FakeResponse.new
      expected_uri = item['uri'] + '/?force=true'
      item.data.delete('type')
      expect(client).to receive(:rest_put).with(expected_uri, { 'body' => item.data }, 1000).and_return(fake_response)
      item.update
    end

    context 'when storage system has not uri' do
      it 'should throw IncompleteResource error' do
        item = described_class.new(client, name: 'without uri')
        expect { item.update }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end
end
