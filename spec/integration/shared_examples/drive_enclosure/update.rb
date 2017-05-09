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

RSpec.shared_examples 'DriveEnclosureUpdateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.find_by(current_client, {}).first }

  describe '#update' do
    it 'raises MethodUnavailable' do
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#get_port_map' do
    it 'retrieves all drive enclosures in the appliance' do
      expect(item.get_port_map).not_to be_empty
    end
  end

  describe '#set_refresh_state' do
    it 'sets the refresh state to RefreshPending' do
      expect { item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end

  describe '#patch' do
    it 'sends a patch request to the resource' do
      old_state = item['uidState']
      new_state = old_state == 'On' ? 'Off' : 'On'
      expect { item.patch('replace', '/uidState', new_state) }.not_to raise_error
      item.retrieve!
      expect(item['uidState']).to eq(new_state)
      expect { item.patch('replace', '/uidState', old_state) }.not_to raise_error
      item.retrieve!
      expect(item['uidState']).to eq(old_state)
    end
  end
end
