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

RSpec.describe OneviewSDK::API1800::C7000::LogicalInterconnect do
  include_context 'shared context'

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::API1800::C7000::LogicalInterconnect.from_file(@client_1800, fixture_path) }

  it 'inherits from OneviewSDK::API1600::C7000::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API1600::C7000::LogicalInterconnect
  end

  describe '#get_igmp_settings' do
    it 'get_igmp_settings' do
      item = log_int
      expect(@client_1800).to receive(:rest_get).with("#{item['uri']}/igmpSettings")
                                                .and_return(FakeResponse.new(members: [{ igmpIdleTimeoutInterval: 260 }]))
      results = item.get_igmp_settings
      expect(results).to_not be_empty
      expect(results.first['igmpIdleTimeoutInterval']).to eq(260)
    end
  end

  describe '#update_igmp_settings' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::API1800::C7000::LogicalInterconnect.new(@client_1800).update_igmp_settings }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to update/)
    end

    it 'does a PUT to uri/igmpSettings & updates @data' do
      item = log_int
      expect(@client_1800).to receive(:rest_put).with(item['uri'] + '/igmpSettings', Hash, item.api_version)
                                                .and_return(FakeResponse.new(key: 'val'))
      item.update_igmp_settings
      expect(item['key']).to eq('val')
    end
  end
end
