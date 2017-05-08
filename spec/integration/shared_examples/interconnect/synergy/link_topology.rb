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

RSpec.shared_examples 'LinkTopologyExample' do |context_name|
  include_context context_name

  describe '#get_link_topologies' do
    it 'retrieves the interconnect link topologies' do
      topologies = {}
      expect { topologies = described_class.get_link_topologies(current_client) }.not_to raise_error
      expect(topologies).not_to be_empty
    end
  end

  describe '#get_link_topology' do
    it 'retrieves the interconnect link topology with the name' do
      link_topology = described_class.get_link_topologies(current_client).first
      link_name = link_topology['name']
      link_topology_found = nil
      expect { link_topology_found = described_class.get_link_topology(current_client, link_name) }.not_to raise_error
      expect(link_topology_found['name']).to eq(link_name)
    end
  end
end
