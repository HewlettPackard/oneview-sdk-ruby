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

require_relative '../../_client' # Gives access to @client

# List of synergy interconnect link topologies
OneviewSDK::Interconnect.get_link_topologies(@client).each do |link_topology|
  puts "Interconnect link topology #{link_topology['name']} URI=#{interconnect['uri']}"
end

# Retrieve single interconnect synergy interconnect link topology
link_topology = OneviewSDK::Interconnect.get_link_topology(@client, 'topology_1')
puts "Link topology name: #{link_topology['name']}, uri: #{link_topology['uri']}"
