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

RSpec.shared_examples 'VolumeSnapshotPoolUpdateExample' do |context_name|
  include_context context_name

  describe '#update snapshot pool' do
    it 'updating the snapshot pool' do
      volume = described_class.find_by(current_client, name: VOLUME4_NAME).first
      storage_pools = resource_class_of('StoragePool').find_by(current_client, storageSystemUri: volume['storageSystemUri'])
      old_snapshot_pool = resource_class_of('StoragePool').find_by(current_client, uri: volume['snapshotPoolUri']).first
      new_snapshot_pool = storage_pools.reject { |pool| pool['uri'] == old_snapshot_pool['uri'] }.first
      volume.set_snapshot_pool(new_snapshot_pool)
      volume.update
      volume.retrieve!
      expect(volume['snapshotPoolUri']).to eq(new_snapshot_pool['uri'])
      # Returning to original snapshot pool
      volume.set_snapshot_pool(old_snapshot_pool)
      volume.update
      volume.retrieve!
      expect(volume['snapshotPoolUri']).to eq(old_snapshot_pool['uri'])
    end
  end
end
