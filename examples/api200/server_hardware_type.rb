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

# Example: List server hardware types

type = 'server hardware type'

# List all server hardware types
list = OneviewSDK::ServerHardwareType.find_by(@client, {})
puts "\n#{type.capitalize} list:"
list.each { |p| puts "  #{p[:name]}" }

unless list.empty?
  item = list.first

  # Rename a server hardware type
  old_name = item[:name]
  new_name = old_name.tr(' ', '_') + '_'
  item.update(name: new_name, description: '')
  puts "\nRe-named: '#{old_name}' to '#{new_name}'"

  # Restore previous name
  item.update(name: old_name)
  puts "\nRestored original name: '#{old_name}'"
end
