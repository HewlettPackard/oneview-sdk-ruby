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

klass = OneviewSDK::API300::C7000::Datacenter
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    @item = klass.find_by($client, name: DATACENTER1_NAME).first
  end

  describe '#update' do
    it 'Changes name' do
      @item.update(name: DATACENTER1_NAME_UPDATED)
      expect(@item[:name]).to eq(DATACENTER1_NAME_UPDATED)
      @item.refresh
      @item.update(name: DATACENTER1_NAME) # Put it back to normal
      expect(@item[:name]).to eq(DATACENTER1_NAME)
    end
  end
end
