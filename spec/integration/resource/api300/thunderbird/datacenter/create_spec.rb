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

klass = OneviewSDK::API300::Synergy::Datacenter
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#add' do
    it 'Add datacenter with default values' do
      options = {
        name: DATACENTER1_NAME,
        width: 5000,
        depth: 5000
      }
      item = klass.new($client_300_synergy, options)
      item.add
      expect(item['uri']).not_to be_empty
    end

    it 'Add datacenter with specified properties' do
      options = {
        name: DATACENTER2_NAME,
        width: 5000,
        depth: 5000,
        coolingCapacity: 5,
        costPerKilowattHour: 0.10,
        currency: 'USD',
        deratingType: 'NaJp',
        deratingPercentage: 20.0,
        defaultPowerLineVoltage: 220,
        coolingMultiplier: 1.5
      }
      item = klass.new($client_300_synergy, options)
      item.add
      expect(item['uri']).not_to be_empty
      options.each do |key, value|
        expect(item[key.to_s]).to eq(value)
      end
    end

    it 'Add datacenter including an existing rack' do
      options = {
        name: DATACENTER3_NAME,
        width: 5000,
        depth: 5000
      }
      item = klass.new($client_300_synergy, options)
      item.add
      expect(item['uri']).not_to be_empty
    end
  end

  describe '#get_visual_content' do
    it 'Gets utilization data' do
      item = klass.find_by($client_300_synergy, name: DATACENTER1_NAME).first
      expect { item.get_visual_content }.not_to raise_error
    end
  end
end
