require_relative '_client' # Gives access to @client

# Example for adding a Datacenter with default values
datacenter = OneviewSDK::Datacenter.new(@client, name: 'MyDatacenter', width: 5000, depth: 5000)
datacenter.create
puts "Datacenter #{datacenter['name']} was created with uri='#{datacenter['uri']}'"


# Updating datacenter name
datacenter.update(name: 'Datacenter')
puts "Datacenter MyDatacenter name changed to #{datacenter['name']}"

# Deleting recently created datacenter
datacenter.delete
