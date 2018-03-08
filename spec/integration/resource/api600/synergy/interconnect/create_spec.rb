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

klass = OneviewSDK::API500::Synergy::Interconnect
RSpec.describe klass, integration: true, type: CREATE do
  let(:current_client) { $client_500_synergy }
  let(:interconnect_name) { INTERCONNECT_4_NAME }
  let(:interconnect_type) { 'Virtual Connect SE 16Gb FC Module for Synergy' }

  include_examples 'InterconnectCreateExample', 'integration api500 context', 500
  include_examples 'LinkTopologyExample', 'integration api500 context'
end
