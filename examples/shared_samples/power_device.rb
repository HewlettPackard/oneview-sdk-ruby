# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../_client' # Gives access to @client

# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @client
#   @ipdu_hostname (hostname or IP address)
#   @ipdu_username
#   @ipdu_password
# NOTE: You'll need to have an IPDU:

# All supported APIs for Power Device:
# - 200, 300, 500

raise 'ERROR: Must set @client in _client.rb' unless @client
raise 'ERROR: Must set @ipdu_hostname in _client.rb' unless @ipdu_hostname
raise 'ERROR: Must set @ipdu_username in _client.rb' unless @ipdu_username
raise 'ERROR: Must set @ipdu_password in _client.rb' unless @ipdu_password

# Resources classes that you can use for Power Device in this example:
# power_device_class = OneviewSDK::API200::PowerDevice
# power_device_class = OneviewSDK::API300::C7000::PowerDevice
# power_device_class = OneviewSDK::API300::Synergy::PowerDevice
# power_device_class = OneviewSDK::API500::C7000::PowerDevice
# power_device_class = OneviewSDK::API500::Synergy::PowerDevice

# Resources classes that you can use for Client Certificate in this example:
# client_certificate_class = OneviewSDK::API200::ClientCertificate
# client_certificate_class = OneviewSDK::API300::C7000::ClientCertificate
# client_certificate_class = OneviewSDK::API300::Synergy::ClientCertificate
# client_certificate_class = OneviewSDK::API500::C7000::ClientCertificate
# client_certificate_class = OneviewSDK::API500::Synergy::ClientCertificate

# Resources classes that you can use for Web Server Certificate in this example:
# web_certificate_class = OneviewSDK::API200::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::Synergy::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::Synergy::WebServerCertificate

# Resource classes used in this sample
power_device_class = OneviewSDK.resource_named('PowerDevice', @client.api_version)
client_certificate_class = OneviewSDK.resource_named('ClientCertificate', @client.api_version)
web_certificate_class = OneviewSDK.resource_named('WebServerCertificate', @client.api_version)

options = {
  username: @ipdu_username,
  password: @ipdu_password,
  hostname: @ipdu_hostname
}

# Adding a Power Device
item = power_device_class.new(@client, name: 'Power_Device_1', ratedCapacity: 500)
puts "\nAdding a power device with default values with name #{item['name']}."
item.add
item.retrieve!
puts "\nPower device  added sucessfully with name #{item['name']} and uri #{item['uri']}."

# Gets utilization data
puts "\nGets utilization for Power Device with name \n #{item['name']}."
item = power_device_class.find_by(@client, {}).first
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

has_ipdu = true
begin
  web_certificate = web_certificate_class.get_certificate(@client, @ipdu_hostname)
rescue OneviewSDK::NotFound
  has_ipdu = false
end

# continues the examples if exists IPDU on the network
if has_ipdu
  # Importing certificate for remote server
  client_certificate = client_certificate_class.new(@client, aliasName: @ipdu_hostname)
  unless client_certificate.retrieve!
    client_certificate['base64SSLCertData'] = web_certificate['base64Data']
    client_certificate['aliasName'] = @ipdu_hostname
    client_certificate.import
  end

  # iPDU Discover
  puts "\nDiscovering ipdu."
  item2 = power_device_class.discover(@client, options)
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
  ipdu_list = power_device_class.find_by(@client, 'managedBy' => { 'hostName' => @ipdu_hostname })
  item3 = ipdu_list.reject { |ipdu| ipdu['managedBy']['id'] == ipdu['id'] }.first
  item3.set_refresh_state(options2)
  puts "\nRefresh sucessfully."

  # Sets the state of Power Device
  puts "\nSets the state of Power Device."
  item4 = ipdu_list.reject { |ipdu| ipdu['model'] != 'Managed Ext. Bar Outlet' }.first
  item4.set_power_state('On')
  puts "\nState changed sucessfully."

  # Deletes power device
  puts "\nRemoving the Power Device with name #{item4['name']}."
  item4.remove
  puts "\nPower Device was sucessfully removed."
end
