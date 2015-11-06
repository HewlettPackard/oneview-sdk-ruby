require_relative '_client' # Gives access to @client

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
