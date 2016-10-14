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

klass = OneviewSDK::API300::Thunderbird::DriveEnclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :each do
    @item = klass.find_by($client_300, {}).first
  end

  describe '#get_port_map' do
    it 'retrieves all drive enclosures in the appliance' do
      expect(@item.get_port_map).not_to be_empty
    end
  end

  describe '#set_refresh_state' do
    it 'sets the refresh state to RefreshPending' do
      expect { @item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end

  describe '#patch' do
    it 'sends a patch request to the resource' do
      expect { @item.patch('replace', '/uidState', 'On') }.not_to raise_error
    end
  end
end
