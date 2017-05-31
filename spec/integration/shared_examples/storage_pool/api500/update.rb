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

RSpec.shared_examples 'StoragePoolUpdateExample API500' do
  include_context 'integration api500 context'

  let(:storage_pool) { described_class.get_all($client_500).first }

  describe '#manage' do
    it 'should change the storage pool to managed/unmanaged' do
      item = described_class.find_by($client_500, isManaged: false).first

      expect(item['isManaged']).to eq(false)
      expect { item.manage(true) }.not_to raise_error
      item.refresh
      expect(item['isManaged']).to eq(true)

      expect { item.manage(false) }.not_to raise_error
      item.refresh
      expect(item['isManaged']).to eq(false)
    end
  end

  describe '#request_refresh' do
    it 'should request a refresh of a storage pool' do
      last_refresh_time = Time.parse(storage_pool['lastRefreshTime'])
      expect { storage_pool.request_refresh }.not_to raise_error
      storage_pool.refresh
      new_last_refresh_time = Time.parse(storage_pool['lastRefreshTime'])
      expect(new_last_refresh_time > last_refresh_time).to eq(true)
    end
  end
end
