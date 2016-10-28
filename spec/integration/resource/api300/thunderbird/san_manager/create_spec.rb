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
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'can create resources' do
      item = klass.new($client_300)
      item['providerDisplayName'] = SAN_PROVIDER1_NAME
      item['connectionInfo'] = [
        {
          'name' => 'Host',
          'value' => $secrets['san_manager_ip']
        },
        {
          'name' => 'Port',
          'value' => 5989
        },
        {
          'name' => 'Username',
          'value' => $secrets['san_manager_username']
        },
        {
          'name' => 'Password',
          'value' => $secrets['san_manager_password']
        }
        # ,
        # {
        #   'name' => 'UseSsl',
        #   'value' => true
        # }
      ]
      expect { item.add }.not_to raise_error
      expect(item['uri']).to be
    end
  end

  describe '#self.get_default_connection_info' do
    it 'Retrieve connection info for provider' do
      expect { klass.get_default_connection_info($client_300, SAN_PROVIDER1_NAME) }.to_not raise_error
    end
  end
end
