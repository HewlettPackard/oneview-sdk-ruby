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

require_relative '../_client' # Gives access to @client

def pretty(arg)
  return puts arg if arg.instance_of?(String)
  puts JSON.pretty_generate(arg)
end

# Example: Retrieve information about a switch
# NOTE: This will retrieve a switch the use it's methods to list the options

# Retrieve the Switch
switch = OneviewSDK::Switch.find_by(@client, {}).first
puts "\nRetrieved switch '#{switch[:name]}' sucessfully.\n  uri = '#{switch[:uri]}'"

sleep(10)

# List all the available Switch Types
switch_type_list = OneviewSDK::Switch.get_types(@client)
puts "\nThe switch types available are: "
switch_type_list.each { |type| puts type['name'] }

# List Switch environmental configuration
pretty "\nThe switch #{switch[:name]} environmental_configuration are:"
pretty switch.environmental_configuration
