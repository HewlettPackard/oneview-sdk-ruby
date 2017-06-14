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

RSpec.shared_examples 'VolumeTemplateUpdateExample' do |context_name|
  include_context context_name

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::VolumeTemplate.new(current_client, name: VOL_TEMP_NAME)
      expect(item.retrieve!).to eq(true)
      expect(item[:name]).to eq(VOL_TEMP_NAME)
    end
  end

  describe '#update' do
    it 'update volume name' do
      item = OneviewSDK::VolumeTemplate.new(current_client, name: VOL_TEMP_NAME)
      item.retrieve!

      item.update(name: VOL_TEMP_NAME_UPDATED)
      item.refresh
      expect(item[:name]).to eq(VOL_TEMP_NAME_UPDATED)

      item.update(name: VOL_TEMP_NAME)
      item.refresh
      expect(item[:name]).to eq(VOL_TEMP_NAME)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::VolumeTemplate.find_by(current_client, {}).map { |item| item[:name] }
      expect(names).to include(VOL_TEMP_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: VOL_TEMP_NAME }
      names = OneviewSDK::VolumeTemplate.find_by(current_client, attrs).map { |item| item[:name] }
      expect(names).to include(VOL_TEMP_NAME)
    end
  end
end
