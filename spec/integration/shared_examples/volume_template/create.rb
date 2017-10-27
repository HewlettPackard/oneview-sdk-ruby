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

RSpec.shared_examples 'VolumeTemplateCreateExample' do |context_name|
  include_context context_name

  let(:storage_system_data) { { credentials: { ip_hostname: current_secrets['storage_system1_ip'] } } }
  let(:storage_system) { resource_class_of('StorageSystem').find_by(current_client, storage_system_data).first }
  let(:storage_pool_data) { { name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'] } }
  let(:storage_pool) { resource_class_of('StoragePool').find_by(current_client, storage_pool_data).first }

  context 'create actions' do
    let(:options) do
      {
        name: VOL_TEMP_NAME,
        state: 'Normal',
        description: 'Volume Template',
        type: 'StorageVolumeTemplateV3'
      }
    end
    let(:item) { described_class.new(current_client, options) }

    before do
      item.set_provisioning(true, 'Thin', 2 * 1024 * 1024 * 1024, storage_pool)
      item.set_storage_system(storage_system)
      item.set_snapshot_pool(storage_pool)
    end

    describe '#create' do
      it 'can create resources' do
        expect { item.create }.to_not raise_error
        expect(item.retrieve!).to eq(true)
        expect(item[:name]).to eq(VOL_TEMP_NAME)
        expect(item[:description]).to eq('Volume Template')
        expect(item[:stateReason]).to eq('None')
        expect(item[:type]).to eq('StorageVolumeTemplateV3')
      end
    end

    describe '#create!' do
      it 'should retrieve!, delete, and create the resource' do
        expect { item.create! }.to_not raise_error
        expect(item.retrieve!).to eq(true)
        list = described_class.find_by(current_client, name: VOL_TEMP_NAME)
        expect(list.size).to eq(1)
      end
    end
  end
end
