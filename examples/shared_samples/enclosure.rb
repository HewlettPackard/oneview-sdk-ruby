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

# Example: Add an enclosure
# NOTE: This will add an enclosure named 'OneViewSDK-Test-Enclosure', then delete it.
#   It will create a bulk of ethernet networks and then delete them.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Enclosure
# api_version = 300 & variant = C7000 to enclosure_class
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Enclosure
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Enclosure
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::Enclosure

# Resource Class used in this sample
enclosure_class = OneviewSDK.resource_named('Enclosure', @client.api_version)

# EnclosureGroup class used in this sample
encl_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)

encl_group = encl_group_class.get_all(@client).first

type = 'enclosure'
encl_name = 'OneViewSDK-Test-Enclosure'

variant = OneviewSDK.const_get("API#{@client.api_version}").variant unless @client.api_version < 300

options = if variant == 'Synergy'
            {
              name: encl_name,
              hostname: @synergy_enclosure_hostname
            }
          else
            {
              name: encl_name,
              hostname: @enclosure_hostname,
              username: @enclosure_username,
              password: @enclosure_password,
              enclosureGroupUri: encl_group['uri'],
              licensingIntent: 'OneView'
            }
          end

item = enclosure_class.new(@client, options)

puts "\nAdding an #{type} with name = '#{item[:name]}'"
if variant == 'Synergy'
  enclosures_added = item.add
  enclosures_added.each do |encl|
    puts "\nAdded #{type} '#{encl[:name]}' sucessfully.\n  uri = '#{encl[:uri]}'"
  end
  encl_name = 'OneViewSDK-Test-Enclosure1'
else
  item.add
  puts "\nAdded #{type} '#{item[:name]}' successfully.\n  uri = '#{item[:uri]}'"
end

item2 = enclosure_class.new(@client, name: encl_name)
puts "\nRetrieving and #{type} by name: '#{item2[:name]}'"
item2.retrieve!
puts "\nFound #{type} by name: '#{item2[:name]}'.\n  uri = '#{item2[:uri]}'"

item2.retrieve!
puts "\nUpdating an #{type} with name = '#{item2[:name]}' and uri = '#{item2[:uri]}'"
old_name = item2['name']
item2.update(name: 'Enclosure_Updated')
item2.retrieve!
puts "\nUpdated #{type} with new name = '#{item2[:name]}' successfully.\n  uri = '#{item2[:uri]}'"

if @client.api_version >= 600
  csr_data = {
      "type": "CertificateDtoV2",
      "organization": "",
      "organizationalUnit": "",
      "locality": "",
      "state": "",
      "country": "",
      "commonName": ""
  }
  csr_data_post = item2.create_csr_request(csr_data)
  puts csr_data_post
  csr_data = item2.get_csr_request
  puts csr_data
end

puts "\nUpdating to original name"
item2.update(name: old_name)
puts "\nUpdated #{type} with original name = '#{item2[:name]}' successfully.\n  uri = '#{item2[:uri]}'"

puts "\nGetting the environmental configuration"
config = item2.environmental_configuration
puts config

puts "\nGetting the utilization data"
utilization = item2.utilization
puts utilization

puts "\nGetting the utilization data by day"
utilization = item2.utilization(view: 'day')
puts utilization

puts "\nGetting the utilization data by fields"
utilization = item2.utilization(fields: %w[AmbientTemperature])
puts utilization

puts "\nGetting the utilization data by filters"
t = Time.now
utilization = item2.utilization(startDate: t)
puts utilization

puts "\nGetting the script"
script = item2.script
puts script

puts "\nReapplying the appliance's configuration on the enclosure"
item2.configuration
puts "\nReapplication applied successfully!"

puts "\nRefreshing the enclosure"
item2.set_refresh_state('RefreshPending')
puts "\nOperation applied successfully!"

# This section illustrates scope usage with the enclosure. Supported in API 300 and onwards.
# When a scope uri is added to a enclosure, the enclosure is grouped into a resource pool.
# Once grouped, with the scope it's possible to restrict an operation or action.
puts "\nOperations with scope."
begin
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create

  puts "\nAdding scopes to the enclosure"
  item2.add_scope(scope_1)
  item2.refresh
  puts 'Scopes:', item2['scopeUris']

  puts "\nReplacing scopes inside the enclosure"
  item2.replace_scopes(scope_2)
  item2.refresh
  puts 'Scopes:', item2['scopeUris']

  puts "\nRemoving scopes from enclosure"
  item2.remove_scope(scope_1)
  item2.remove_scope(scope_2)
  item2.refresh
  puts 'Scopes:', item2['scopeUris']

  scope_1.refresh
  scope_2.refresh

  # Delete scopes
  scope_1.delete
  scope_2.delete
rescue NoMethodError
  puts "\nScope operations is not supported in this version."
end

# Removes an enclosure
# NOTE: to remove Enclosures on Synergy requires them to be physically removed first
puts "\nAttempting removal of enclosure with name = '#{item2[:name]}' and uri = '#{item2[:uri]}'"
begin
  item2.remove
  puts "\n#{type} '#{name}' removed successfully!"
rescue OneviewSDK::TaskError
  puts "\nRemoving Synergy enclosures on OneView requires the enclosures to be physically disconnected first."
end
