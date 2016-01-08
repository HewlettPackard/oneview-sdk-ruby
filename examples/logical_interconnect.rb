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
puts "Logical interconnect #{log_int['name']} was retrieved sucessfully"

puts '#### Update of Internal networks ####'

internal_networks = log_int.list_vlan_networks
puts 'Listing all the internal networks'
internal_networks.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

et01 = OneviewSDK::EthernetNetwork.new(@client, name: 'li_et01')
et02 = OneviewSDK::EthernetNetwork.new(@client, name: 'li_et02')

puts "\nUpdating internal networks"
log_int.update_internal_networks(et01, et02)

internal_networks2 = log_int.list_vlan_networks
puts 'Listing all the internal networks again'
internal_networks2.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

puts "\nReturning to initial state"
log_int.update_internal_networks()

internal_networks3 = log_int.list_vlan_networks
puts 'Listing all the internal networks one more time'
internal_networks3.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

# This method is too dangerous to be used, it may misconfigure your appliance.
# Be wise...
# Delete interconnect
# log_int.delete
# puts "Deleted #{log_int[:name]}"
