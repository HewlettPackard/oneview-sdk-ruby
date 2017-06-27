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

RSpec.shared_examples 'VolumeUpdateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: VOLUME2_NAME).first }
  let(:namespace) { described_class.to_s[0, described_class.to_s.rindex('::')] }
  let(:storage_system) { Object.const_get("#{namespace}::StorageSystem").get_all(current_client).first }
  let(:storage_pool) { Object.const_get("#{namespace}::StoragePool").get_all(current_client).first }
  let(:vol_template) do
    Object.const_get("#{namespace}::VolumeTemplate").find_by(current_client, name: VOL_TEMP_NAME).first
  end

  describe '#update' do
    it 'updating the volume name' do
      item.update(name: "#{VOLUME2_NAME}_Updated")
      item.retrieve!
      expect(item['name']).to eq("#{VOLUME2_NAME}_Updated")
      # Returning to original name
      item.update(name: VOLUME2_NAME)
      item.retrieve!
      expect(item['name']).to eq(VOLUME2_NAME)
    end
  end

  describe '#snapshot' do
    it 'retrieve list' do
      expect(item.get_snapshots).not_to be_empty
    end

    it 'retrieve by name' do
      expect(item.get_snapshot(VOL_SNAPSHOT_NAME)).not_to be_empty
    end
  end

  describe '#set_storage_volume_template' do
    it 'set_storage_volume_template' do
      item = described_class.new(current_client, name: VOLUME_NAME)
      vol_template.retrieve!
      item.set_storage_volume_template(vol_template)
      expect(item['templateUri']).to eq(vol_template['uri'])
    end
  end

  describe '#get_attachable_volumes' do
    it 'gets all the attachable volumes managed by the appliance' do
      expect { described_class.get_attachable_volumes(current_client) }.to_not raise_error
    end
  end

  describe '#get_extra_managed_volume_paths' do
    it 'gets the list of extra managed storage volume paths' do
      expect { described_class.get_extra_managed_volume_paths(current_client) }.to_not raise_error
    end
  end
end
