require_relative '_client'

type = 'Logical Interconnect'

# Explores functionalities of Logical Interconnects

# Retrieves test enclosure to put the interconnects
enclosure = OneviewSDK::Enclosure.new(@client, name: 'OneViewSDK_Test_Enclosure')
enclosure.retrieve!
puts "Sucessfully retrieved the enclosure #{enclosure[:name]}"

log_int = OneviewSDK::LogicalInterconnect.new(@client, {})

# Create interconnect in Bay 1 of Enclosure
log_int.create(1, enclosure[:uri])
puts "Created a new interconnect #{log_int[:name]}"

log_int.delete
