# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
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

RSpec.describe OneviewSDK::API2400::C7000::LogicalInterconnect do
  include_context 'shared context'

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::API2400::C7000::LogicalInterconnect.from_file(@client_2400, fixture_path) }

  it 'inherits from OneviewSDK::API2200::C7000::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API2200::C7000::LogicalInterconnect
  end

  describe '#update_port_flap_settings' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::API2400::C7000::LogicalInterconnect.new(@client_2400).update_port_flap_settings }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to update/)
    end

    it 'does a PUT to uri/portFlapSettings & updates @data' do
      item = log_int
      expect(@client_2400).to receive(:rest_put).with(item['uri'] + '/portFlapSettings', Hash, item.api_version)
                                                .and_return(FakeResponse.new(key: 'val'))
      item.update_port_flap_settings
      expect(item['key']).to eq('val')
    end
  end
end
