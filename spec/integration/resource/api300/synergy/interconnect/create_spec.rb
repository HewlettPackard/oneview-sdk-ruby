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

klass = OneviewSDK::API300::Synergy::Interconnect
RSpec.describe klass, integration: true, type: CREATE do
  include_context 'integration api300 context'

  let(:interconnect) { klass.find_by($client_300_synergy, name: INTERCONNECT1_NAME).first }
  let(:interconnect_type) { 'Virtual Connect SE 16Gb FC Module for Synergy' }

  describe '#create' do
    it 'self raises MethodUnavailable' do
      item = klass.new($client_300_synergy)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#name_servers' do
    it 'retrieves name servers' do
      expect { interconnect.name_servers }.not_to raise_error
    end
  end

  describe '#statistics' do
    it 'gets statistics' do
      expect { interconnect.statistics }.not_to raise_error
    end

    it 'gets statistics for a specific port' do
      port = interconnect[:ports].first
      expect { interconnect.statistics(port['name']) }.not_to raise_error
    end
  end

  describe '#get_types' do
    it 'retrieves interconnect types' do
      expect { klass.get_types($client_300_synergy) }.not_to raise_error
    end
  end

  describe '#get_type' do
    it 'retrieves the interconnect type with name' do
      interconnect_type_found = nil
      expect { interconnect_type_found = klass.get_type($client_300_synergy, interconnect_type) }.not_to raise_error
      expect(interconnect_type_found['name']).to eq(interconnect_type)
    end
  end

  describe '#get_link_topologies' do
    it 'retrieves the interconnect link topologies' do
      topologies = nil
      expect { topologies = klass.get_link_topologies($client_300_synergy) }.not_to raise_error
      expect(topologies).not_to be_empty
    end
  end

  describe '#get_link_topology' do
    it 'retrieves the interconnect link topology with the name' do
      link_topology = klass.get_link_topologies($client_300_synergy).first
      link_name = link_topology['name']
      link_topology_found = nil
      expect { link_topology_found = klass.get_link_topology($client_300_synergy, link_name) }.not_to raise_error
      expect(link_topology_found['name']).to eq(link_name)
    end
  end
end
