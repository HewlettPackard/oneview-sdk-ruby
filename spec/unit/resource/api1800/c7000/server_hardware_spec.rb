# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

RSpec.describe OneviewSDK::API1800::C7000::ServerHardware do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1600::C7000::ServerHardware' do
    expect(described_class).to be < OneviewSDK::API1600::C7000::ServerHardware
  end

  before(:each) do
    @item = OneviewSDK::API1800::C7000::ServerHardware.new(@client_1800, uri: '/rest/fake')
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      expect(@item[:type]).to eq('server-hardware-12')
    end
  end

  describe '#get_local_storage' do
    it 'Makes a GET call on local storage' do
      expect(@client_1800).to receive(:rest_get).with(@item['uri'] + '/localStorage')
                                                .and_return(FakeResponse.new({}))
      @item.get_local_storage
    end
  end

  describe '#get_local_storagev2' do
    it 'Makes a GET call on local storagev2' do
      expect(@client_1800).to receive(:rest_get).with(@item['uri'] + '/localStorageV2')
                                                .and_return(FakeResponse.new({}))
      @item.get_local_storagev2
    end
  end
end
