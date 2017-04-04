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

RSpec.shared_examples 'ScopeUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'should update the scope' do
      old_name = item['name']
      item['name'] = "#{old_name} Updated"

      expect { item.update }.not_to raise_error
      item.refresh
      expect(item['name']).to eq("#{old_name} Updated")

      # coming back to original name
      item['name'] = old_name
      expect { item.update }.not_to raise_error
    end
  end

  describe '#unset_resources' do
    it 'should update the scope' do
      expect { item.unset_resources(enclosure, server_hardware) }.to_not raise_error

      enclosure.refresh
      server_hardware.refresh

      expect(enclosure['scopeUris']).to be_empty
      expect(server_hardware['scopeUris']).to be_empty
    end
  end

end
