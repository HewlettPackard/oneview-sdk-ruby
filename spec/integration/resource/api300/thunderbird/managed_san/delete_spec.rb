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

klass = OneviewSDK::API300::Synergy::ManagedSAN
extra_klass = OneviewSDK::API300::Synergy::FCNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe 'Remove FC Networks' do
    it 'Remove' do
      klass.find_by($client_300_synergy, deviceManagerName: $secrets['san_manager_ip']).each do |san|
        fc = extra_klass.new($client_300_synergy, name: "FC_#{san['name']}")
        fc.retrieve!
        fc.delete
      end
    end
  end
end
