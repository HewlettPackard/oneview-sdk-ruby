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

RSpec.describe OneviewSDK::API500::C7000::ServerHardware do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::ServerHardware' do
    expect(described_class).to be < OneviewSDK::API300::C7000::ServerHardware
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_500)
      expect(item['type']).to eq('server-hardware-7')
      expect(item['scopeUris']).to be_empty
    end
  end

  describe '#get_physical_server_hardware' do
    it 'raises exception when uri is null' do
      item = described_class.new(@client_500)
      expect { item.get_physical_server_hardware }.to raise_error(/Please set uri attribute before interacting with this resource/)
    end

    it 'getting the physical server hardware inventory' do
      item = described_class.new(@client_500, uri: 'rest/fake')
      fake_response = FakeResponse.new
      expect(@client_500).to receive(:rest_get).with('rest/fake/physicalServerHardware').and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('fake')
      expect(item.get_physical_server_hardware).to eq('fake')
    end
  end
end
