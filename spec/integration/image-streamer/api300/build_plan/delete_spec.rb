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

require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::BuildPlan
RSpec.describe klass, integration_i3s: true, type: DELETE, sequence: i3s_rseq(klass) do
  include_context 'integration i3s api300 context'

  describe '#delete' do
    it 'removes a plan script' do
      item = klass.find_by($client_i3s_300, name: BUILD_PLAN1_NAME_UPDATED).first
      item2 = klass.find_by($client_i3s_300, name: BUILD_PLAN2_NAME).first
      item3 = klass.find_by($client_i3s_300, name: BUILD_PLAN3_NAME).first
      expect(item['uri']).to be
      expect(item2['uri']).to be
      expect(item3['uri']).to be
      expect { item.delete }.not_to raise_error
      expect(item.retrieve!).to eq(false)
      expect { item2.delete }.not_to raise_error
      expect(item2.retrieve!).to eq(false)
      expect { item3.delete }.not_to raise_error
      expect(item3.retrieve!).to eq(false)
    end
  end
end