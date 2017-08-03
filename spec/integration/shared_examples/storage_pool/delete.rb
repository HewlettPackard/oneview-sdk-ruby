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

RSpec.shared_examples 'StoragePoolDeleteExample' do |context_name|
  include_context context_name

  let(:storage_system_options) do
    {
      credentials: {
        ip_hostname: $secrets['storage_system1_ip']
      }
    }
  end
  let(:storage_system_class) do
    namespace = described_class.to_s[0, described_class.to_s.rindex('::')]
    Object.const_get("#{namespace}::StorageSystem")
  end

  describe '#delete' do
    it 'should throw unavailable exception' do
      item = described_class.new(current_client)
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#remove' do
    it 'deletes the resource' do
      storage_system_ref = storage_system_class.new(current_client, storage_system_options)
      storage_system_ref.retrieve!
      item = described_class.new(current_client, name: STORAGE_POOL_NAME, storageSystemUri: storage_system_ref['uri'])
      item.retrieve!

      expect { item.remove }.to_not raise_error
      expect(item.retrieve!).to eq(false)
    end
  end
end
