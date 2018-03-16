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

require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ServerHardware do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::ServerHardware' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ServerHardware
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_600)
      expect(item['type']).to eq('server-hardware-8')
    end
  end

  describe '#add_multiple_servers' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler)
          .and_return(name: 'En1OA1,bay 1', serialNumber: 'Fake', uri: '/rest/fake')

        @data = {
          'mpHostsAndRanges' => '["hostname.domain", "1.1.1.1-1.1.1.10"]',
          'username' => 'Admin',
          'password' => 'secret123',
          'licensingIntent' => 'OneView',
          'other' => 'blah'
        }
        @server_hardware = OneviewSDK::API600::C7000::ServerHardware.new(@client_600, @data)
      end

      it 'only sends certain attributes on the POST' do
        data = @data.reject { |k, _v| k == 'other' }
        expect(@client_600).to receive(:rest_post).with('/rest/server-hardware/discovery', { 'body' => data }, anything)
        @server_hardware.add_multiple_servers
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        server_hardware = OneviewSDK::API600::C7000::ServerHardware.new(@client_600, {})
        expect { server_hardware.add_multiple_servers }.to raise_error(OneviewSDK::IncompleteResource, /Missing required attribute/)
      end
    end
  end
end
