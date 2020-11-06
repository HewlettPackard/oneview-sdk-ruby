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

# Supported Variants:
# C7000 and Synergy for all API versions
#
# Resource Class used in this sample
enclosure_class = OneviewSDK.resource_named('Enclosure', @client.api_version)

# EnclosureGroup class used in this sample
encl_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)

encl_group = encl_group_class.get_all(@client).first

type = 'enclosure'
encl_name = '0000A66101'

variant = 'Synergy'

scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
scope_1 = scope_class.new(@client, name: 'Scope_for_enclosure')
scope_1.create

options = {
  name: encl_name,
  hostname: @enclosure_hostname,
  username: @enclosure_username,
  password: @enclosure_password,
  enclosureGroupUri: encl_group['uri'],
  licensingIntent: 'OneView',
  initialScopeUris: [scope_1['uri']]
}

item = enclosure_class.new(@client, options)

puts "\nAdding an #{type} with name = '#{item[:name]}'"
if variant == 'C7000'
  enclosures_added = item.add
  enclosures_added.each do |encl|
    puts "\nAdded #{type} '#{encl[:name]}' sucessfully.\n  uri = '#{encl[:uri]}'"
  end
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
  # Gets a enclosure by scopeUris
  query = {
    scopeUris: scope_1['uri']
  }
  puts "\nGets a enclosure with scope '#{query[:scopeUris]}'"
  item4 = enclosure_class.get_all_with_query(@client, query)
  puts "Found enclosure '#{item4}'."

  if variant == 'C7000'
    bay_number = 1
  elsif variant == 'Synergy'
    bay_number = nil
  end

  csr_data = {
    type: 'CertificateDtoV2',
    organization: 'Acme Corp.',
    organizationalUnit: 'IT',
    locality: 'Townburgh',
    state: 'Mississippi',
    country: 'US',
    email: 'admin@example.com',
    commonName: 'fe80::2:0:9:1%eth2'
  }
  # Generate Certificate Signing Request for the enclosure
  item2.create_csr_request(csr_data, bay_number)
  puts "Created CSR Request for Enclosure with name = '#{item2[:name]}' and uri = '#{item2[:uri]}'"

  # Retrieve Certificate Signing Request for the enclosure
  certificate = item2.get_csr_request(bay_number)
  puts "Certificate Request data for Enclosure with name = '#{item2[:name]}' and uri = '#{item2[:uri]}'"

  certificate_data = {
    type: 'CertificateDataV2',
    base64Data: certificate['base64Data']
  }

  # Imports a signed server certificate into the enclosure
  begin
    import = item2.import_certificate(certificate_data, bay_number)
    puts import
  rescue StandardError => msg
    puts msg
  end
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

if @client.api_version < 500
  puts "\nGetting the script"
  script = item2.script
  puts script
end

puts "\nReapplying the appliance's configuration on the enclosure"
item2.configuration
puts "\nReapplication applied successfully!"

puts "\nRefreshing the enclosure"
item2.set_refresh_state('RefreshPending')
puts "\nOperation applied successfully!"

# This section illustrates scope usage with the enclosure. Supported in API 300 till 500.
# When a scope uri is added to a enclosure, the enclosure is grouped into a resource pool.
# Once grouped, with the scope it's possible to restrict an operation or action.
if @client.api_version < 600
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

scope_1.delete
