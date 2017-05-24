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

# Example: Actions with Managed SAN
# NOTE: You'll need to have a Managed SAN added.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#  @san_manager_ip (hostname or IP address)
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::ManagedSAN
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::ManagedSAN
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::ManagedSAN
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::ManagedSAN
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::ManagedSAN

# Resource Class used in this sample
managed_san_class = OneviewSDK.resource_named('ManagedSAN', @client.api_version)

# List managed SANs for a specified SAN Manager
puts "\nListing the managed SANs:"
managed_san_class.find_by(@client, deviceManagerName: @san_manager_ip).each do |san|
  puts "- #{san['name']}"
end

puts "\nCreating a FC Network with a managed SAN"
item = managed_san_class.find_by(@client, deviceManagerName: @san_manager_ip, isExpectedFc: true).first
options = {
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach',
  name: "FC_#{item['name']}",
  managedSanUri: item['uri']
}

fc_network_class = OneviewSDK.resource_named('FCNetwork', @client.api_version)
fc_network = fc_network_class.new(@client, options)
fc_network.create!
puts "\nCreated FC Network with name = #{fc_network['name']} and managed SAN uri = #{fc_network['managedSanUri']}"

# sleep to make sure the timing until the SAN is 'managed' isn't off
sleep(20)

# Set SAN policy
puts "\nSetting the SAN policy"
policy = {
  zoningPolicy: 'SingleInitiatorAllTargets',
  zoneNameFormat: '{hostName}_{initiatorWwn}',
  enableAliasing: true,
  initiatorNameFormat: '{hostName}_{initiatorWwn}',
  targetNameFormat: '{storageSystemName}_{targetName}',
  targetGroupNameFormat: '{storageSystemName}_{targetGroupName}'
}
item.set_san_policy(policy)
puts "\nSAN policy updated successfully."
puts item['sanPolicy']

# Set public attributes
puts "\nSetting the public attributes"
begin
  attributes = [
    {
      name: 'MetaSan',
      value: 'Neon SAN',
      valueType: 'String',
      valueFormat: 'None'
    }
  ]

  item.set_public_attributes(attributes)
  puts "\nPublic attributes updated successfully."
rescue OneviewSDK::MethodUnavailable => e
  puts "\n#{e}: Method available for: API 200 & API 500 onwards - Only."
end

# Gets endpoints
puts "\nGetting endpoints"
endpoints = item.get_endpoints
puts "\nListing the endpoints: \n#{endpoints}"

# Gets the wwn of a switch being used by a managed SAN, then uses it to query all SANs associated with that WWN
puts "\nGetting the wwn of a switch being used by a managed SAN, then uses it to query all SANs associated with that WWN"
begin
  wwn = managed_san_class.find_by(@client, {}).last['principalSwitch']

  managed_san_class.get_wwn(@client, wwn).each { |san| puts "\n Found the following SAN associated with the WWN informed:\n #{san}" }
rescue NoMethodError
  puts "\nThe method #get_wwn is available from API 300 onwards."
end

# Clean up
fc_network.delete
