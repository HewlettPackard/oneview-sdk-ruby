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

RSpec.describe OneviewSDK::API2000::C7000::LogicalInterconnect do
  include_context 'shared context'

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::API2000::C7000::LogicalInterconnect.from_file(@client_2000, fixture_path) }

  it 'inherits from OneviewSDK::API1800::C7000::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API1800::C7000::LogicalInterconnect
  end

  describe '#bulk_inconsistency_validate' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::API2000::C7000::LogicalInterconnect.new(@client_2000).bulk_inconsistency_validate }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to validate/)
    end

    it 'gets the inconsistency report for bulk update' do
      item = log_int
      options = {
        'logicalInterconnectUris' => []
      }
      expect(@client_2000).to receive(:rest_post).with(item.class::BASE_URI + '/bulk-inconsistency-validation', { 'body' => options }, item.api_version)
                                                 .and_return(FakeResponse.new)
      item.bulk_inconsistency_validate
    end
  end
end
