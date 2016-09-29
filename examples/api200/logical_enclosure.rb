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


# Get first logical enclosure
logical_enclosure = OneviewSDK::LogicalEnclosure.find_by(@client, {}).first
puts "Found logical-enclosure '#{logical_enclosure[:name]}'."

# Retrieve logical enclosure by name
logical_enclosure_2 = OneviewSDK::LogicalEnclosure.new(@client, name: logical_enclosure['name'])
logical_enclosure_2.retrieve!
puts "Retrieved logical-enclosure '#{logical_enclosure_2[:name]}' by name."


# Get configuration script
orig_script = logical_enclosure.get_script
puts "Retrieved logical-enclosure '#{logical_enclosure[:name]}' script\n  Content = '#{orig_script}'"

# Set configuration script
logical_enclosure.set_script('test')
puts "Setting logical-enclosure '#{logical_enclosure[:name]}' configuration script"

# Get configuration script
puts "Retrieved logical-enclosure '#{logical_enclosure[:name]}' script\n  Content = '#{logical_enclosure.get_script}'"

# Reset configuration script
logical_enclosure.set_script(orig_script)


# Update from Group
logical_enclosure.update_from_group
puts 'Logical enclosure updated'


# Generate dump
dump = {
  errorCode: 'Mydump',
  encrypt: false,
  excludeApplianceDump: false
}
logical_enclosure.support_dump(dump)
puts "\nGenerated dump for logical-enclosure '#{logical_enclosure[:name]}'."
