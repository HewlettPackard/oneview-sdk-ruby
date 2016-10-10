# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

klass = OneviewSDK::API300::Thunderbird::SASLogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:item) { klass.new($client_300, name: SAS_LOG_INT_GROUP_NAME) }

  describe '#update' do
    it 'adding and removing uplink set' do
      item.retrieve!

      expect { item.update }.not_to raise_error

      expect(item['uri']).to be
    end
  end
end
