require_relative '_client' # Gives access to @client

# Example: Add server hardware
# NOTE: This will add an available server hardware device, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @server_hardware_hostname (hostname or IP address)
#   @server_hardware_username
#   @server_hardware_password

type = 'server hardware'
options = {
  hostname: @server_hardware_hostname,
  username: @server_hardware_username,
  password: @server_hardware_password,
  licensingIntent: 'OneView'
}

item = OneviewSDK::ServerHardware.new(@client, options)
item.create
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Find recently created item by name
matches = OneviewSDK::ServerHardware.find_by(@client, name: item[:name])
item2 = matches.first
fail "Failed to find #{type} by name: '#{item[:name]}'" unless matches.first
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

# Retrieve recently created item
item3 = OneviewSDK::ServerHardware.new(@client, name: item[:name])
item3.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item3[:uri]}'"

# List all server hardware
puts "\n\n#{type.capitalize} list:"
OneviewSDK::ServerHardware.find_by(@client, {}).each do |p|
  puts "  #{p[:name]}"
end

# Delete this item
item.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."
