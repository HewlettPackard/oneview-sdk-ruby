# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../_client' # Gives access to @client

# Example: Create/Update/Delete hypervisor manager
# NOTE: This will create a hypervisor manager named 'vcenter.corp.com', update it and then delete it.
#

# Supported Variants:
# - C7000 and Synergy for all API versions

raise 'ERROR: Must set @hypervisor_manager_ip in _client.rb' unless @hypervisor_manager_ip
raise 'ERROR: Must set @hypervisor_manager_username in _client.rb' unless @hypervisor_manager_username
raise 'ERROR: Must set @hypervisor_manager_password in _client.rb' unless @hypervisor_manager_password

# Resource Class used in this sample
hypervisor_manager_class = OneviewSDK.resource_named('HypervisorManager', @client.api_version)

options = {
  name: @hypervisor_manager_ip,
  username: @hypervisor_manager_username,
  password: @hypervisor_manager_password
}

hm = hypervisor_manager_class.new(@client, options)

# Find recently created hypervisor manager by name
matches = hypervisor_manager_class.find_by(@client, name: hm[:name])
hm2 = matches.first
puts "\nFound hypervisor-manager by name: '#{hm2[:name]}'.\n  uri = '#{hm2[:uri]}'"

if not hm2
  hm.create!
  puts "\nCreated hypervisor-manager '#{hm[:name]}' sucessfully.\n  uri = '#{hm[:uri]}'"
end


# Retrieve recently created hypervisor manager
hm3 = hypervisor_manager_class.new(@client, name: hm[:name])
hm3.retrieve!
puts "\nRetrieved hypervisor-manager data by name: '#{hm3[:name]}'.\n  uri = '#{hm3[:uri]}'"

# Update hypervisor manager registration
attribute = { name: @hypervisor_manager_ip }
hm2.update(attribute)
puts "\nUpdated hypervisor-manager: '#{hm2[:name]}'.\n  uri = '#{hm2[:uri]}'"
puts "with attribute: #{attribute}"

# Example: List all hypervisor managers certain attributes
attributes = { name: @hypervisor_manager_ip }
puts "\nHypervisor manager with #{attributes}"
hypervisor_manager_class.find_by(@client, attributes).each do |hypervisor_manager|
  puts "  #{hypervisor_manager[:name]}"
end

# Delete this hypervisor manager
hm2.delete
puts "\nSucessfully deleted hypervisor-manager '#{hm[:name]}'."
