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

klass = OneviewSDK::API300::Thunderbird::SANManager
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :each do
    @item = klass.new($client_300_thunderbird, name: $secrets_thunderbird['san_manager_ip'])
    @item.retrieve!
  end

  describe '#update' do
    it 'refresh a SAN Device Manager' do
      expect { @item.update(refreshState: 'RefreshPending') }.not_to raise_error
    end

    it 'Update hostname and credentials' do
      connection_info = [
        {
          'name' => 'Host',
          'value' => $secrets_thunderbird['san_manager_ip']
        },
        {
          'name' => 'SnmpPort',
          'value' => 161
        },
        {
          'name' => 'SnmpUserName',
          'value' => $secrets_thunderbird['san_manager_username']
        },
        {
          'name' => 'SnmpAuthLevel',
          'value' => 'AUTHNOPRIV'
        },
        {
          'name' => 'SnmpAuthProtocol',
          'value' => 'SHA'
        },
        {
          'name' => 'SnmpAuthString',
          'value' => $secrets_thunderbird['san_manager_password']
        }
      ]
      expect { @item.update(connectionInfo: connection_info) }.not_to raise_error
    end

    it 'Update invalid field' do
      expect { @item.update(name: 'SANManager_01') }.to raise_error(OneviewSDK::BadRequest)
    end
  end
end
