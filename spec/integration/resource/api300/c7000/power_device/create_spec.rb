# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::API300::C7000::PowerDevice
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#add' do
    it 'can add a power device with default values' do
      item = klass.new($client_300, name: POW_DEVICE1_NAME, ratedCapacity: 500)
      item.add
      expect(item['uri']).not_to be_empty
    end
  end

  describe '#discover' do
    it 'can discover an HP iPDU' do
      options = {
        username: $secrets['hp_ipdu_username'],
        password: $secrets['hp_ipdu_password'],
        hostname: $secrets['hp_ipdu_ip']
      }

      ipdu = klass.discover($client_300, options)
      expect(ipdu['uri']).not_to be_empty
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      item = klass.find_by($client_300, {}).first
      expect { item.utilization }.not_to raise_error
    end
  end
end
