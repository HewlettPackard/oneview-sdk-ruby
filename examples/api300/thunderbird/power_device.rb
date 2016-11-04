# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../_client' # Gives access to @client

# Example: Add an Power Device
# NOTE: This will add an Power Device named 'Power_Device_1', then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @ipdu_hostname (hostname or IP address)
#   @ipdu_username
#   @ipdu_password

options = {
  username: @ipdu_username,
  password: @ipdu_password,
  hostname: @ipdu_hostname
}

# Adding a Power Device
item = OneviewSDK::API300::Thunderbird::PowerDevice.new(@client, name: 'Power_Device_1', ratedCapacity: 500)
puts "\nAdding a power device with default values with name #{item['name']}."
item.add
item.retrieve!
puts "\nPower device  added sucessfully with name #{item['name']} and uri #{item['uri']}."

# Gets utilization data
puts "\nGets utilization for Power Device with name \n #{item['name']}."
item = OneviewSDK::API300::Thunderbird::PowerDevice.find_by(@client, {}).first
item.utilization
puts "\nUtilization for Power Device with name \n #{item['name']} sucessfully."

# Updating the Power Device
new_name = 'PowerDevice_Name_Updated'
puts "\nUpdating a Power Device with name #{item['name']} for a new name #{new_name}."
item.update(name: new_name)
puts "\nPower Device updated sucessfully."

# Deletes power device
puts "\nRemoving the Power Device with name #{item['name']}."
item.remove
puts "\nPower Device was sucessfully removed."

# iPDU Discover
puts "\nDiscovering ipdu."
item2 = OneviewSDK::API300::Thunderbird::PowerDevice.discover(@client, options)
puts "IPDU with uri #{item2['uri']} was discovered sucessfully."

# List iPDU power connections
puts "\nPower connections for #{item2['name']}."
item2['powerConnections'].each do |connection|
  puts "\n- Power connection uri='#{connection['connectionUri']}'"
end

# Refresh a Power Device
puts "\nRefresh a Power Device"
options2 = {
  refreshState: 'RefreshPending',
  username: @ipdu_username,
  password: @ipdu_password,
  hostname: @ipdu_hostname
}
ipdu_list = OneviewSDK::API300::Thunderbird::PowerDevice.find_by(@client, 'managedBy' => { 'hostName' => @ipdu_hostname })
item3 = ipdu_list.reject { |ipdu| ipdu['managedBy']['id'] == ipdu['id'] }.first
item3.set_refresh_state(options2)
puts "\nRefresh sucessfully."

# Sets the state of Power Device
puts "\nSets the state of Power Device."
item4 = ipdu_list.reject { |ipdu| ipdu['model'] != 'Managed Ext. Bar Outlet' }.first
item4.set_power_state('On')
puts "\nState changed sucessfully."
