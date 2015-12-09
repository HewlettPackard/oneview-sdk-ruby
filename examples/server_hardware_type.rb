require_relative '_client' # Gives access to @client

# Example: List server hardware types

type = 'server hardware type'

# List all server hardware types
list = OneviewSDK::ServerHardwareType.find_by(@client, {})
puts "\n#{type.capitalize} list:"
list.each { |p| puts "  #{p[:name]}" }

if list.size > 0
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
