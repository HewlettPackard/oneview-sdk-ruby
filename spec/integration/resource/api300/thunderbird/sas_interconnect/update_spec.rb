# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::API300::Synergy::SASInterconnect
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:sas_interconnect_type) { 'Synergy 12Gb SAS Connection Module' }
  let(:sas_interconnect) { klass.new($client_300_synergy, name: SAS_INTERCONNECT1_NAME) }

  before :each do
    sas_interconnect.retrieve!
  end
  describe '#get_type' do
    it 'retrieves all types of SAS interconnects supported by the appliance' do
      types = klass.get_types($client_300_synergy)
      expect(types).not_to be_empty
    end

    it 'retrieves a specific type of SAS interconnect supported by the appliance' do
      type = klass.get_type($client_300_synergy, sas_interconnect_type)
      expect(type).not_to be_empty
    end
  end

  describe '#set_refresh_state' do
    it 'sets the refresh state of the SAS interconnect successfully' do
      expect { sas_interconnect.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end


  describe '#patch' do
    it 'resets the SAS interconnect successfully' do
      expect { sas_interconnect.patch('replace', '/hardResetState', 'Reset') }.not_to raise_error
    end
  end
end
