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

require_relative '../_client' # Gives access to @client

# Setup:
options = {
  name:  'My_Server_Profile',
  description: 'Short Description'
}

item = OneviewSDK::ServerProfile.new(@client, options)

json_file = "#{File.dirname(File.expand_path(__FILE__))}/temp_resource.json"
yaml_file = "#{File.dirname(File.expand_path(__FILE__))}/temp_resource.yml"


# Example 1: Save a resource to a file
item.to_file(json_file)
puts "\nSaved '#{item[:name]}' (#{item.class}) to file: #{json_file}"

item.to_file(yaml_file)
puts "Saved '#{item[:name]}' (#{item.class}) to file: #{yaml_file}"


# Example 2: Load a resource from a file
item2 = OneviewSDK::Resource.from_file(@client, json_file)
puts "\nLoaded '#{item2[:name]}' (#{item.class}) from file: #{json_file}"

item3 = OneviewSDK::Resource.from_file(@client, yaml_file)
puts "Loaded '#{item3[:name]}' (#{item.class}) from file: #{yaml_file}"


# Cleanup
File.delete(json_file)
File.delete(yaml_file)
puts "\nDeleted temporary files"
