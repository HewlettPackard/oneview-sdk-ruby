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

RSpec.describe OneviewSDK::API1200::C7000::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::C7000::EthernetNetwork' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::EthernetNetwork
  end

  describe '#bulk_create' do
    let(:options) do
      {
        vlanIdRange: '26-28',
        purpose: 'General',
        namePrefix: 'Ethernet_Network'
      }
    end
    it 'returns true' do
      file = File.read('spec/support/fixtures/unit/resource/ethernet_networks_members.json')
      networks = JSON.parse(file)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(networks, 200))
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new({}, 202))
      expect_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return({})
      list = OneviewSDK::API1200::C7000::EthernetNetwork.bulk_create(@client_1200, options)
      expect(list.length).to eq(3)
    end
  end
end
