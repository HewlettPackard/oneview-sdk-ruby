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

RSpec.shared_examples 'VolumeSnapshotPoolUpdateExample API600' do |context_name|
  include_context context_name

  describe '#update snapshot pool' do
    it 'updating the snapshot pool' do
      volume = described_class.find_by(current_client, name: VOLUME5_NAME).first
      old_snapshot_pool = resource_class_of('StoragePool').find_by(current_client, uri: volume['deviceSpecificAttributes']['snapshotPoolUri']).first
      new_snapshot_pool = resource_class_of('StoragePool').find_by(current_client, isManaged: false).first
      new_snapshot_pool.manage(true)
      volume.set_snapshot_pool(new_snapshot_pool)
      volume.update
      volume.retrieve!
      expect(volume['deviceSpecificAttributes']['snapshotPoolUri']).to eq(new_snapshot_pool['uri'])
      # Returning to original snapshot pool
      volume.set_snapshot_pool(old_snapshot_pool)
      volume.update
      volume.retrieve!
      expect(volume['deviceSpecificAttributes']['snapshotPoolUri']).to eq(old_snapshot_pool['uri'])
      new_snapshot_pool.manage(false)
    end
  end
end
