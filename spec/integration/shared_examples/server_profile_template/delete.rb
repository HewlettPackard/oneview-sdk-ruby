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

RSpec.shared_examples 'ServerProfileTemplateDeleteExample' do |context_name|
  include_context context_name

  let(:names) { [SERVER_PROFILE_TEMPLATE_NAME, SERVER_PROFILE_TEMPLATE2_NAME, SERVER_PROFILE_TEMPLATE3_NAME, SERVER_PROFILE_TEMPLATE4_NAME] }
  let(:item) { described_class.find_by(current_client, name: SERVER_PROFILE_TEMPLATE3_NAME).first }
  api_version = described_class.to_s.split('::')[1]

  describe '#remove_connection' do
    it 'removes a connection by name', if: api_version.end_with?('200', '300') do
      expect(item['connections'].size).to eq(2)
      item.remove_connection(CONNECTION2_NAME)
      expect(item['connections'].size).to eq(1)
    end

    it 'removes a connection by name', if: api_version.end_with?('500') do
      expect(item['connectionSettings']['connections'].size).to eq(2)
      item.remove_connection(CONNECTION2_NAME)
      expect(item['connectionSettings']['connections'].size).to eq(1)
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
    it 'deletes the associated Server profiles' do
      names.each do |name|
        item = described_class.find_by(current_client, name: name).first
        profiles = resource_class_of('ServerProfile').find_by(current_client, serverProfileTemplateUri: item['uri'])
        profiles.each do |profile|
          expect { profile.delete }.to_not raise_error
        end
      end
    end

    it 'deletes all the resources' do
      names.each do |name|
        item = described_class.find_by(current_client, name: name).first
        expect(item).to be
        expect { item.delete }.to_not raise_error
        expect(item.retrieve!).to eq(false)
      end
    end
  end
end
