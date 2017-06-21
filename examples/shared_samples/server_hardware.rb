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

require_relative '../_client' # Gives access to @client

# Example: Example for server hardware
# NOTE: This will add an available server hardware device, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @server_hardware_hostname (hostname or IP address)
#   @server_hardware_username
#   @server_hardware_password
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::ServerHardware
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::ServerHardware
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::ServerHardware
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::ServerHardware
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::ServerHardware

# Resource Class used in this sample
server_harware_class = OneviewSDK.resource_named('ServerHardware', @client.api_version)

type = 'server hardware'
options = {
  hostname: @server_hardware_hostname,
  username: @server_hardware_username,
  password: @server_hardware_password,
  licensingIntent: 'OneView'
}

puts "\nAdding #{type} with hostname = '#{@server_hardware_hostname}'"
item = server_harware_class.new(@client, options)
item.add
puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Find recently created item by name
puts "\nSearch server by name = #{item[:name]}"
matches = server_harware_class.find_by(@client, name: item[:name])
item2 = matches.first
raise "Failed to find #{type} by name: '#{item[:name]}'" unless matches.first
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

# List all server hardware
puts "\n\n#{type.capitalize} list:"
server_harware_class.get_all(@client).each do |p|
  puts "  #{p[:name]}"
end

# Retrieve recently created item
puts "\nSearch server by hostname = #{@server_hardware_hostname}"
item3 = server_harware_class.new(@client, hostname: @server_hardware_hostname)
item3.retrieve!
puts "\nFound #{type} by hostname: '#{item3[:hostname]}'.\n  uri = '#{item3[:uri]}'"

puts "\nGetting list of bios UEFI values"
bios = item3.get_bios
puts "\nList of bios UEFI found sucessfully."
puts bios

puts "\nRetrieving the URL to launch a Single Sign-On (SSO) session for the iLO web interface"
sso_url = item3.get_ilo_sso_url
puts "\nSSO found sucessfully. \nUrl: #{sso_url['iloSsoUrl']}"

puts "\nGenerating a Single Sign-On (SSO) session for the iLO Java Applet console and returns the URL to launch it"
java_sso_url = item3.get_java_remote_sso_url
puts "\nJava remote SSO found sucessfully. \nUrl: #{java_sso_url['javaRemoteConsoleUrl']}"

puts "\nGenerating a Single Sign-On (SSO) session for the iLO Integrated Remote Console Application (IRC) and returns the URL to launch it."
remote_console_url = item3.get_remote_console_url
puts "\nRemote console found sucessfully. \nUrl: #{remote_console_url['remoteConsoleUrl']}"

puts "\nGetting the settings that describe the environmental configuration."
environmental = item3.environmental_configuration
puts "\nEnviromental configuration found sucessfully: \n#{environmental}"

puts "\nRetrieving historical utilization data for the specified resource, metrics, and time span."
utilization = item3.utilization
puts "\nHistorical utilization retrieved sucessfully: \n#{utilization}"

puts "\nRetrieving historical utilization with day view."
utilization2 = item3.utilization(view: 'day')
puts "\nHistorical utilization retrieved sucessfully: \n#{utilization2}"

utilization3 = item3.utilization(fields: %w(AmbientTemperature))
puts "\nRetrieving historical utilization with AmbientTemperature field."
puts "\nHistorical utilization retrieved sucessfully: \n#{utilization3}"

puts "\nRetrieving historical utilization by date."
t = Time.now
utilization4 = item3.utilization(startDate: t)
puts "\nHistorical utilization retrieved sucessfully: \n#{utilization4}"

# Get a firmware inventory by id
begin
  puts "\nGet a firmware with id :'#{item3[:uri]}'"
  response = item3.get_firmware_by_id
  puts "\nFound firware inventory by id: '#{item3[:uri]}'."
  puts "\nuri firmware = '#{response['uri']}', server name = '#{response['serverName']}' and server moldel= '#{response['serverModel']}',"
rescue NoMethodError
  puts 'The method #get_pluggable_module_information is available only for api greater than or equal to 300.'
end

# Get a list of firmware inventory across all servers
begin
  puts 'Get a list of firmware without filters'
  response = item3.get_firmwares
  puts "\nFound firware inventory: '#{response}'."

  puts 'Get a list of firmware with filters componentName and serverName'
  filters = [
    { name: 'components.componentName', operation: '=', value: 'iLO' },
    { name: 'serverName', operation: '=', value: @server_hardware_hostname }
  ]
  response2 = item3.get_firmwares(filters)
  puts "\nFound firware inventory: '#{response2}'."
rescue NoMethodError
  puts 'The method #get_pluggable_module_information is available only for api greater than or equal to 300.'
end

# This section illustrates scope usage with the server hardware. Supported in API 300 and onwards.
# When a scope uri is added to a server hardware, the server hardware is grouped into a resource pool.
# Once grouped, with the scope it's possible to restrict an operation or action.
puts "\nOperations with scope."
begin
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create

  puts "\nAdding scopes to the server hardware"
  item3.add_scope(scope_1)
  item3.refresh
  puts 'Scopes:', item3['scopeUris']

  puts "\nReplacing scopes inside the server hardware"
  item3.replace_scopes(scope_2)
  item3.refresh
  puts 'Scopes:', item3['scopeUris']

  puts "\nRemoving scopes from server hardware"
  item3.remove_scope(scope_1)
  item3.remove_scope(scope_2)
  item3.refresh
  puts 'Scopes:', item3['scopeUris']

  scope_1.refresh
  scope_2.refresh

  # Delete scopes
  scope_1.delete
  scope_2.delete
rescue NoMethodError
  puts "\nScope operations is not supported in this version."
end

# Delete this item
puts "\nRemoving the #{type} with name = '#{item[:name]}'."
item3.remove
puts "\n#{type} was removed sucessfully."
