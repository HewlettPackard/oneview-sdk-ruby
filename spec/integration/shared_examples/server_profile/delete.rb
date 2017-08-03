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

RSpec.shared_examples 'ServerProfileDeleteExample' do |context_name|
  include_context context_name

  let(:names) { [SERVER_PROFILE_NAME, SERVER_PROFILE2_NAME, SERVER_PROFILE3_NAME, SERVER_PROFILE4_NAME, SERVER_PROFILE5_NAME] }
  let(:item) { described_class.find_by(current_client, name: SERVER_PROFILE4_NAME).first }

  describe '#remove_connection' do
    it 'removes a connection by name' do
      expect(item['connections'].size).to eq(2)
      item.remove_connection(CONNECTION2_NAME)
      expect(item['connections'].size).to eq(1)
    end
  end

  describe '#remove_volume_attachment' do
    it 'removes a volume attachment' do
      expect(item['sanStorage']['volumeAttachments'].size).to eq(1)
      item.remove_volume_attachment(1)
      expect(item['sanStorage']['volumeAttachments'].size).to eq(0)
    end
  end

  describe '#delete' do
    it 'deletes all the resources' do
      names.each do |name|
        item = described_class.find_by(current_client, name: name).first
        expect(item).to be
        expect { item.delete }.to_not raise_error
        expect(item.retrieve!).to eq(false)
      end
      assoc_vol = resource_class_of('Volume').find_by(current_client, name: VOLUME7_NAME).first
      expect { assoc_vol.delete }.to_not raise_error
    end
  end
end
