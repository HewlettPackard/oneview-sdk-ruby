# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
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

# All supported APIs for Event:
# - API200 for C7000 and Synergy
# - API300 for C7000 and Synergy
# - API400 for C7000 and Synergy
# - API500 for C7000 and Synergy
# - API600 for C7000 and Synergy

# Resources classes that you can use for Event in this example:
alert_class = OneviewSDK.resource_named('Alerts', @client.api_version)


puts "\n\n Get all alerts:"
alert_class.get_all(@client).each do |item|
  puts item.data
end

puts "\n\n Update assignedToUser"
alert_loc = alert_class.find_by(@client, alertState: 'Locked').first
puts "Data : '#{alert_loc.data}'"
attribute = 'Paul'
alert_loc.update(assignedToUser: attribute)
alert_loc.retrieve!
puts "\nAlert updated successfully and new name = '#{alert_loc['assignedToUser']}'"

puts "\n\n Get Alert by ID/URI"
alert = alert_class.find_by(@client, alertState: 'Cleared').first
alert_id = alert_class.find_by(@client, uri: alert[:uri])[0]
puts "Alert by ID/URI: '#{alert_id.data}'"

puts "\n\n Delete Alert by ID"
alert_id.delete

# NOTE: Locked alerts cannot be deleted
puts "\n\n Delete Alert by _change_log URI"
alert_cl = alert_class.find_by(@client, alertState: 'Cleared').last
puts alert_cl[:changeLog][0]['uri']
puts alert_cl
puts "Alert by Change log ID : '#{alert_cl.data}'"
alert_cl.delete
