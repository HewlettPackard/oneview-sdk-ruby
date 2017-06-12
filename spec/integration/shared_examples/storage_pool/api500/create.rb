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

require 'time'

RSpec.shared_examples 'StoragePoolCreateExample API500' do
  include_context 'integration api500 context'

  let(:network_fc_class) do
    namespace = described_class.to_s[0, described_class.to_s.rindex('::')]
    Object.const_get("#{namespace}::FCNetwork")
  end

  describe '#create' do
    it 'should throw unavailable exception' do
      item = described_class.new($client_500)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '::reachable' do
    it 'should get the storage pools' do
      expect(described_class.reachable($client_500)).not_to be_empty
    end

    it 'should get the storage pools that are connected on the specified networks' do
      storage_pool = described_class.reachable($client_500).first
      network_uri = storage_pool['reachableNetworks'].first
      fc_network = network_fc_class.new($client_500, uri: network_uri)
      expect(described_class.reachable($client_500, [fc_network])).not_to be_empty
    end

    it 'should get the empty list when not connected on the specified networks' do
      fc_network = network_fc_class.new($client_500, uri: '/rest/fc-networks/fake-UUID')
      expect(described_class.reachable($client_500, [fc_network])).to be_empty
    end
  end
end
