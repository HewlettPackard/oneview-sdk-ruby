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

klass = OneviewSDK::API300::Synergy::LogicalDownlink
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#find_by' do
    it 'returns all logical downlinks in the appliance' do
      expect { klass.find_by($client_300_synergy, {}) }.not_to raise_error
    end
  end

  describe '#get_without_ethernet' do
    it 'self raises MethodUnavailable' do
      expect { klass.get_without_ethernet }.to raise_error(/The method #self.get_without_ethernet is unavailable for this resource/)
    end
  end
end
