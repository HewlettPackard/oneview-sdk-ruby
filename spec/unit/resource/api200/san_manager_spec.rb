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

RSpec.describe OneviewSDK::SANManager do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      san_manager = OneviewSDK::SANManager.new(@client_200)
      expect(san_manager['type']).to eq('FCDeviceManagerV2')
    end
  end

  describe '#add' do
    it 'Should support add' do
      san_manager = OneviewSDK::SANManager.new(
        @client_200,
        name: 'san_manager_1',
        providerDisplayName: 'Brocade',
        providerUri: '/rest/fc-sans/providers/100'
      )
      expect(@client_200).to receive(:rest_post).with(
        '/rest/fc-sans/providers/100/device-managers',
        {
          'body' => {
            'name' => 'san_manager_1',
            'providerDisplayName' => 'Brocade',
            'providerUri' => '/rest/fc-sans/providers/100',
            'type' => 'FCDeviceManagerV2'
          }
        },
        200
      ).and_return(FakeResponse.new({}))
      san_manager.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      san_manager = OneviewSDK::SANManager.new(@client_200, uri: '/rest/fake')
      expect(@client_200).to receive(:rest_delete).with('/rest/fake', {}, 200).and_return(FakeResponse.new({}))
      san_manager.remove
    end
  end

  describe '#create' do
    it 'Should raise error if used' do
      san_manager = OneviewSDK::SANManager.new(@client_200)
      expect { san_manager.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'Should raise error if used' do
      san_manager = OneviewSDK::SANManager.new(@client_200)
      expect { san_manager.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#self.get_default_connection_info' do
    it 'Get default connection info' do
      expect(@client_200).to receive(:rest_get).with('/rest/fc-sans/providers').and_return(
        FakeResponse.new(
          'members' => [
            {
              'displayName' => 'FCProvider_01',
              'defaultConnectionInfo' => [
                {
                  'name' => 'Host',
                  'value' => 'san01.hpe.com'
                },
                {
                  'name' => 'Username',
                  'value' => 'user'
                }
              ],
              'uri' => '/rest/providers/100'
            }
          ]
        )
      )
      default_connection = OneviewSDK::SANManager.get_default_connection_info(@client_200, 'FCProvider_01')
      expect(default_connection.first['name']).to eq('Host')
      expect(default_connection.first['value']).to eq('san01.hpe.com')
      expect(default_connection.last['name']).to eq('Username')
      expect(default_connection.last['value']).to eq('user')
    end
  end

end
