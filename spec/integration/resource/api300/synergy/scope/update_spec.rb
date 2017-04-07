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

RSpec.describe OneviewSDK::API300::Synergy::Scope, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  subject(:item) { described_class.get_all($client_300_synergy).first }
  let(:enclosure) { OneviewSDK::API300::Synergy::Enclosure.get_all($client_300_synergy).first }
  let(:server_hardware) { OneviewSDK::API300::Synergy::ServerHardware.get_all($client_300_synergy).first }

  include_examples 'ScopeUpdateExample', 'integration api300 context'
end
