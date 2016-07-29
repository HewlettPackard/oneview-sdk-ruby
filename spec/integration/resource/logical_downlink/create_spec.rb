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

klass = OneviewSDK::LogicalDownlink
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#get_without_ethernet' do
    it 'can get and build logical downlinks without ethernet networks' do
      item = OneviewSDK::LogicalDownlink.find_by($client, {}).first
      logical_downlink_without_ethernet = item.get_without_ethernet
      expect(logical_downlink_without_ethernet.class).to eq(described_class)
    end
  end

  describe '#self.get_without_ethernet' do
    it 'can get and build logical downlinks for a logical downlink without ethernet networks' do
      logical_downlinks = OneviewSDK::LogicalDownlink.get_without_ethernet($client)
      expect(logical_downlinks.first.class).to eq(described_class)
    end
  end
end
