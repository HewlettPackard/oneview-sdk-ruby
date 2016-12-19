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

require_relative '../_client'

# List of interconnects
OneviewSDK::Interconnect.find_by(@client, {}).each do |interconnect|
  puts "Interconnect #{interconnect['name']} URI=#{interconnect['uri']}"

  # Retrieve name servers
  puts " - Name servers: #{interconnect.nameServers}"
end

# Retrieve interconnect
interconnect = OneviewSDK::Interconnect.new(@client, name: 'Encl2, interconnect 2')
interconnect.retrieve!

# Resert Port Protection
puts "Reseting port protection for interconnect #{interconnect['name']}"
interconnect.resetportprotection
