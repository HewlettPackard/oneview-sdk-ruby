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

klass = OneviewSDK::API500::C7000::Switch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'SwitchUpdateExample', 'integration api500 context'

  describe '#set_scope_uris' do
    it 'is unavailable' do
      item = described_class.new($client_500)
      expect { item.set_scope_uris }.to raise_error(OneviewSDK::MethodUnavailable, /The method #set_scope_uris is unavailable/)
    end
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:item) { described_class.find_by(current_client, name: $secrets['logical_switch1_ip']).first }
  end
end
