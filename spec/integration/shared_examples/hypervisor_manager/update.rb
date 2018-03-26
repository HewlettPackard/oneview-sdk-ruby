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

RSpec.shared_examples 'HypervisorManagerUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'updates the hypervisor manager name' do
      item = described_class.new(current_client, name: HYPERVISOR_MGR_NAME)
      item.retrieve!
      item.update(name: HYPERVISOR_MGR_NAME)
      item.refresh
      expect(item[:name]).to eq(HYPERVISOR_MGR_NAME)
      item.update(name: HYPERVISOR_MGR_NAME) # Put it back to normal
      item.refresh
      expect(item[:name]).to eq(HYPERVISOR_MGR_NAME)
    end
  end
end
