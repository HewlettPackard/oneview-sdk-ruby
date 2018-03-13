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

RSpec.shared_examples 'SASInterconnectUpdateExample' do |context_name|
  include_context context_name

  subject(:item) { described_class.get_all(current_client).first }
  let(:sas_interconnect_type) { 'Synergy 12Gb SAS Connection Module' }

  describe '#update' do
    it 'self raises MethodUnavailable' do
      sas_int = described_class.new(current_client)
      expect { sas_int.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#get_type' do
    it 'retrieves all types of SAS interconnects supported by the appliance' do
      types = described_class.get_types(current_client)
      expect(types).not_to be_empty
    end

    it 'retrieves a specific type of SAS interconnect supported by the appliance' do
      type = described_class.get_type(current_client, sas_interconnect_type)
      expect(type).not_to be_empty
    end
  end

  describe '#set_refresh_state' do
    it 'sets the refresh state of the SAS interconnect successfully' do
      expect { item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end

  describe '#patch' do
    it 'changes the SAS interconnect power state' do
      expect { item.patch('replace', '/powerState', 'Off') }.not_to raise_error
      item.retrieve!
      expect(item['powerState']).to eq('Off')
      expect { item.patch('replace', '/powerState', 'On') }.not_to raise_error
      item.retrieve!
      expect(item['powerState']).to eq('On')
    end

    it 'changes the UID for the SAS interconnect' do
      expect { item.patch('replace', '/uidState', 'Off') }.not_to raise_error
      item.retrieve!
      expect(item['uidState']).to eq('Off')
      expect { item.patch('replace', '/uidState', 'On') }.not_to raise_error
      item.retrieve!
      expect(item['uidState']).to eq('On')
    end

    it 'resets with hard reset the SAS interconnect successfully' do
      expect { item.patch('replace', '/hardResetState', 'Reset') }.not_to raise_error
    end

    it 'resets with soft reset the SAS interconnect successfully' do
      expect { item.patch('replace', '/softResetState', 'Reset') }.not_to raise_error
    end
  end
end
