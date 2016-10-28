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

klass = OneviewSDK::API300::Thunderbird::Datacenter
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#remove' do
    it 'removes the resource' do
      datacenters = klass.find_by($client, {})
      datacenters.each do |datacenter|
        datacenter.remove if [DATACENTER1_NAME, DATACENTER2_NAME, DATACENTER3_NAME].include?(datacenter['name'])
      end
      datacenter_after_deletion = klass.find_by($client, {}).map { |datacenter| datacenter['name'] }
      [DATACENTER1_NAME, DATACENTER2_NAME, DATACENTER3_NAME].each { |name| expect(datacenter_after_deletion).not_to include(name) }
    end
  end
end
