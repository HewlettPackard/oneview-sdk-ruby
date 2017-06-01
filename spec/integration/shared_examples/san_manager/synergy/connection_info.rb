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

RSpec.shared_examples 'ConnectionInfoSynergy' do
  let(:connection_info) do
    [
      {
        'name' => 'Host',
        'value' => $secrets_synergy['san_manager_ip']
      },
      {
        'name' => 'SnmpPort',
        'value' => 161
      },
      {
        'name' => 'SnmpUserName',
        'value' => $secrets_synergy['san_manager_username']
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
        'value' => $secrets_synergy['san_manager_password']
      }
    ]
  end
end
