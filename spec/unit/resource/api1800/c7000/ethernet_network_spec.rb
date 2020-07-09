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

RSpec.describe OneviewSDK::API1800::C7000::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1600::C7000::EthernetNetwork' do
    expect(described_class).to be < OneviewSDK::API1600::C7000::EthernetNetwork
  end

  describe '#bulk_delete' do
    let(:options) do
      {
        networkUris: ['/rest/network1', '/rest/network2']
      }
    end

    it 'returns true' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(true)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new({}, 202))
      OneviewSDK::API1800::C7000::EthernetNetwork.bulk_delete(@client_1800, options)
    end
  end
end
