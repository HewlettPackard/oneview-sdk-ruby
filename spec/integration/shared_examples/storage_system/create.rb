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

RSpec.shared_examples 'StorageSystemCreateExample' do |context_name, api_version|
  include_context context_name

  describe '#create' do
    it 'can create resources' do
      item = described_class.new(current_client, item_attributes)
      item.add
      expect(item[:uri]).not_to be_empty

      item_added = described_class.new(current_client, uri: item[:uri])
      expect(item_added.retrieve!).to be true
    end
  end

  describe '#host-types' do
    it 'List Host Types' do
      expect(described_class.get_host_types(current_client)).not_to be_empty
    end
  end

  describe '#storage pools' do
    it 'List Storage Pools' do
      item = described_class.new(current_client, item_attributes)
      item.retrieve!
      expect { item.get_storage_pools }.not_to raise_error
    end
  end

  describe '#get_managed_ports', if: api_version <= 300 do
    it 'lists all the ports' do
      item = described_class.new(current_client, item_attributes)
      item.retrieve!
      expect(item.get_managed_ports).to be_empty
    end
  end

  describe '#retrieve' do
    it 'raises an exception if no identifiers are given' do
      item = described_class.new(current_client, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end

    it 'not retrieves storage system with ip_hostname and invalid data types', if: api_version <= 300 do
      item = described_class.new(current_client, 'credentials' => {})
      item['credentials']['ip_hostname'] = 'fake'
      item.retrieve!
      expect(item.retrieve!).to eq(false)
    end
  end
end
