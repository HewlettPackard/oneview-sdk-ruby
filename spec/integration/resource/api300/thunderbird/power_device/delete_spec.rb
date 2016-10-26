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

klass = OneviewSDK::API300::Thunderbird::PowerDevice
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    before :all do
      @power_device_1 = klass.new($client_300, name: POW_DEVICE1_NAME)
      @power_device_1.retrieve!
      ipdu_list = klass.find_by($client_300, 'managedBy' => { 'hostName' => $secrets['hp_ipdu_ip'] })
      @power_device_2 = ipdu_list.reject { |ipdu| ipdu['managedBy']['id'] == ipdu['id'] }.first
    end

    it 'remove Power device 1' do
      expect { @power_device_1.remove }.to_not raise_error
    end

    it 'remove Power device 2' do
      expect { @power_device_2.remove }.to_not raise_error
    end
  end
end
