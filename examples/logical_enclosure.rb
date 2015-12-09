require_relative '_client'


# Get first logical enclosure
logical_enclosure = OneviewSDK::LogicalEnclosure.find_by(@client, {}).first
puts "Found logical-enclosure '#{logical_enclosure[:name]}'.\n uri = '#{logical_enclosure[:uri]}'"

# Retrieve logical enclosure with name 'Encl2'
logical_enclosure_2 = OneviewSDK::LogicalEnclosure.new(@client, name: 'Encl2')
logical_enclosure_2.retrieve!
puts "Retrieved logical-enclosure '#{logical_enclosure_2[:name]}'.\n uri = '#{logical_enclosure_2[:uri]}'"


# Get configuration script
puts "Retrieved logical-enclosure '#{logical_enclosure[:name]}'.\n script = '#{logical_enclosure.get_script}'"

# Set configuration script
logical_enclosure.set_script('test')
puts "Setting logical-enclosure '#{logical_enclosure[:name]}'.\n configuration script"

# Get configuration script
puts "Retrieved logical-enclosure '#{logical_enclosure[:name]}'.\n script = '#{logical_enclosure.get_script}'"

# Reset configuration script
logical_enclosure.set_script('')

# Update from Group
logical_enclosure.updateFromGroup
puts 'Logical enclosure updated'

# Generate dump
dump = {
  errorCode: 'Mydump',
  encrypt: false,
  excludeApplianceDump: false
}
logical_enclosure.support_dumps(dump)
puts "\nGenerated logical-enclosure '#{logical_enclosure[:name]}' dump"
