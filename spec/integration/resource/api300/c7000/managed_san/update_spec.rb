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

klass = OneviewSDK::API300::C7000::ManagedSAN
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :each do
    @item = klass.find_by($client_300, state: 'Managed').first
  end

  describe 'Check if SANs were imported' do
    it 'check if SAN was imported' do
      # sleep to make sure the timing until the SANs are 'managed' isn't off
      sleep 10
      klass.find_by($client_300, deviceManagerName: $secrets['san_manager_ip']).each do |san|
        expect(san['state']).to eq('Managed')
      end
    end
  end

  describe '#get_endpoints' do
    it 'Get the SAN endpoints' do
      expect { @item.get_endpoints }.not_to raise_error
    end
  end

  describe '#set_refresh_state' do
    it 'Refresh SAN' do
      expect { @item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end

  describe '#set_public_attributes' do
    it 'Update public attributes' do
      expect { @item.set_public_attributes(name: 'MetaSan') }.to raise_error(/The method #set_public_attributes is unavailable for this resource/)
    end
  end

  describe '#set_san_policy' do
    it 'Update san policy' do
      policy = {
        zoningPolicy: 'SingleInitiatorAllTargets',
        zoneNameFormat: '{hostName}_{initiatorWwn}',
        enableAliasing: true,
        initiatorNameFormat: '{hostName}_{initiatorWwn}',
        targetNameFormat: '{storageSystemName}_{targetName}',
        targetGroupNameFormat: '{storageSystemName}_{targetGroupName}'
      }
      expect { @item.set_san_policy(policy) }.not_to raise_error
      @item.refresh
      item_policy = @item['sanPolicy']
      policy.each do |key, value|
        expect(value).to eq(item_policy[key.to_s])
      end
    end
  end

  describe '#get_zoning_report' do
    it 'Get issues' do
      expect { @item.get_zoning_report }.not_to raise_error
    end
  end

  describe '#get_wwn' do
    it 'Gets all SANs associated with a specific SAN manager' do
      wwn = klass.find_by($client_300, {}).last['principalSwitch']
      sans = klass.get_wwn($client_300, wwn)
      expect(sans.first['wwns']).to include(wwn)
    end
  end
end
