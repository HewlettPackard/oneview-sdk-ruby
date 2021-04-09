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

RSpec.describe OneviewSDK::API2800::C7000::LogicalInterconnect do
  include_context 'shared context'

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::API2800::C7000::LogicalInterconnect.from_file(@client_2800, fixture_path) }

  it 'inherits from OneviewSDK::API2600::C7000::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API2600::C7000::LogicalInterconnect
  end
end
