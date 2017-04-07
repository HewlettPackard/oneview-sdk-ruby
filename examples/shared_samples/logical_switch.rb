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

# Example: Create/Update/Delete logical switch
# NOTE: This will create an logical switch named 'LogicalSwitch', update it and then delete it.
#
# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000
# - API500 for Synergy

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::LogicalSwitch
# api_version = 300 & variant = C7000 to logical_switch_class
# api_version = 300 & variant = Synergy to logical_switch_class
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LogicalSwitch
# api_version = 500 & variant = Synergy to OneviewSDK::API500::C7000::LogicalSwitch

# Resource Class used in this sample
logical_switch_class = OneviewSDK.resource_named('LogicalSwitch', @client.api_version)

def internal_link_set_test_helper(logical_switch_class)
  # List of Internal Link Sets
  puts 'List of Internal Link Sets.'
  logical_switch_class.get_internal_link_sets(@client).each do |internal_link_set|
    puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}"
  end

  # Retrieves a specific Internal Link Set
  puts 'Retrieves a specific Internal Link Set.'
  internal_link_set = logical_switch_class.get_internal_link_set(@client, 'ils1')
  puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}" if internal_link_set
end

variant = OneviewSDK.const_get("API#{@client.api_version}").variant unless @client.api_version < 300

if variant == 'C7000' || @client.api_version < 300
  logical_switch_group_class = OneviewSDK.resource_named('LogicalSwitchGroup_1', @client.api_version)

  # SSH Credential
  ssh_credentials = logical_switch_class::CredentialsSSH.new(@logical_switch_ssh_user, @logical_switch_ssh_password)

  # SNMP credentials
  snmp_v1 = logical_switch_class::CredentialsSNMPV1.new(161, @logical_switch_community_string)
  snmp_v1_2 = logical_switch_class::CredentialsSNMPV1.new(161, @logical_switch_community_string)

  logical_switch_group = logical_switch_group_class.get_all(@client).first

  logical_switch = logical_switch_class.new(
    @client,
    name: 'LogicalSwitch',
    logicalSwitchGroupUri: logical_switch_group['uri']
  )

  # Adding switches credentials
  logical_switch.set_switch_credentials(@logical_switch1_ip, ssh_credentials, snmp_v1)
  logical_switch.set_switch_credentials(@logical_switch2_ip, ssh_credentials, snmp_v1_2)

  # Creates logical switch for a switch group
  logical_switch.create
  puts "Logical switch created with uri=#{logical_switch['uri']}"

  puts 'Reclaiming the top-of-rack switches in a logical switch'
  logical_switch.refresh_state
  puts 'Action done Successfully!'

  if @client.api_version >= 300
    # Test for internal link set
    internal_link_set_test_helper(logical_switch_class)

    scope_class = OneviewSDK.resource_named('Scope', @client.api_version)

    # Scopes
    scope_1 = scope_class.new(@client, name: 'Scope 1')
    scope_1.create
    scope_2 = scope_class.new(@client, name: 'Scope 2')
    scope_2.create

    puts "\nAdding the '#{scope_1['name']}' with URI='#{scope_1['uri']}' in the logical switch"
    logical_switch.add_scope(scope_1)
    logical_switch.refresh
    puts "Listing logical_switch['scopeUris']:"
    puts logical_switch['scopeUris'].to_s

    puts "\nReplacing scopes to '#{scope_1['name']}' with URI='#{scope_1['uri']}' and '#{scope_2['name']}' with URI='#{scope_2['uri']}'"
    logical_switch.replace_scopes(scope_1, scope_2)
    logical_switch.refresh
    puts "Listing logical_switch['scopeUris']:"
    puts logical_switch['scopeUris'].to_s

    puts "\nRemoving scope with URI='#{scope_1['uri']}' from the logical switch"
    logical_switch.remove_scope(scope_1)
    logical_switch.refresh
    puts "Listing logical_switch['scopeUris']:"
    puts logical_switch['scopeUris'].to_s

    puts "\nRemoving scope with URI='#{scope_2['uri']}' from the logical switch"
    logical_switch.remove_scope(scope_2)
    logical_switch.refresh
    puts "Listing logical_switch['scopeUris']:"
    puts logical_switch['scopeUris'].to_s

    # Delete the scopes
    scope_1.delete
    scope_2.delete
  end

  puts "\nDeleting the logical switch"
  logical_switch.delete unless logical_switch.nil?
  puts 'Logical switch deleted successfully' unless logical_switch.retrieve!
else
  # Test for Synergy
  internal_link_set_test_helper(logical_switch_class)
end
