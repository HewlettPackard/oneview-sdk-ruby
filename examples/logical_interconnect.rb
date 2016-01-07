require_relative '_client'

type = 'Logical Interconnect'

# Explores functionalities of Logical Interconnects

# Retrieves test enclosure to put the interconnects
enclosure = OneviewSDK::Enclosure.new(@client, name: 'Encl2')
enclosure.retrieve!
puts "Sucessfully retrieved the enclosure #{enclosure[:name]}"

log_int = OneviewSDK::LogicalInterconnect.new(@client, {name: 'OneViewSDK_Test_Enclosure-FULL_LIG_SDK'})

# Create interconnect in Bay 1 of Enclosure
# log_int.create(1, enclosure)
# puts "Created a new interconnect #{log_int[:name]} with uri #{log_int[:uri]}"

log_int.retrieve!

internal_networks = log_int.list_internal_networks
puts 'Listing all the internal networks'
internal_networks.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

# Delete interconnect
# log_int.delete
# puts "Deleted #{log_int[:name]}"
