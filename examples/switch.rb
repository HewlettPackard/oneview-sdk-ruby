require_relative '_client' # Gives access to @client

def pretty(arg)
  return puts arg if arg.instance_of?(String)
  puts JSON.pretty_generate(arg)
end

# Example: Create an Switch
# NOTE: This will retrieve a switch the use it's methods to list the options

# Retrieve the Switch
switch = OneviewSDK::Switch.find_by(@client, {}).first
puts "\nRetrieved switch '#{switch[:name]}' sucessfully.\n  uri = '#{switch[:uri]}'"

sleep(10)

# List all the available Switch Types
switch_type_list = OneviewSDK::Switch.get_types(@client)
puts "\nThe switch types available are: "
switch_type_list.each { |type| puts type['name']}

# List Switch environmental configuration
pretty "\nThe switch #{switch[:name]} environmental_configuration are:"
pretty switch.environmental_configuration
