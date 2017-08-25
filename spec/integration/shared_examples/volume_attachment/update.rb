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

RSpec.shared_examples 'VolumeAttachmentUpdateExample' do |context_name, options|
  include_context context_name

  describe '#update' do
    it 'should throw unavailable exception' do
      item = described_class.new(current_client)
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '::get_extra_unmanaged_volumes' do
    it 'should get the list of extra unmanaged storage volumes' do
      expect { described_class.get_extra_unmanaged_volumes(current_client) }.to_not raise_error
    end
  end

  describe '::remove_extra_unmanaged_volume' do
    it 'should remove extra presentations from a specific server profile' do
      server_profile = resource_class_of('ServerProfile').find_by(current_client, name: SERVER_PROFILE4_NAME).first
      expect { described_class.remove_extra_unmanaged_volume(current_client, server_profile) }.to_not raise_error
    end
  end

  describe '#get_paths', if: options[:api_version] <= 300 do
    it 'should get a list of volume attachment paths from the attachment' do
      item = described_class.get_all(current_client).first
      expect(item).to be
      expect { item.get_paths }.to_not raise_error
    end
  end

  describe '#get_paths', if: options[:api_version] >= 500 do
    it 'should throw unavailable exception' do
      item = described_class.get_all(current_client).first
      expect(item).to be
      expect { item.get_paths }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end
end
