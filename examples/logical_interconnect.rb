require_relative '_client'

type = 'Logical Interconnect'

# Explores functionalities of Logical Interconnects

# Retrieves test enclosure to put the interconnects
# enclosure = OneviewSDK::Enclosure.new(@client, name: 'Encl1')
# enclosure.retrieve!
# puts "Sucessfully retrieved the enclosure #{enclosure[:name]}"

log_int = OneviewSDK::LogicalInterconnect.new(@client, {name: 'Encl1-Simple'})
log_int.retrieve!
puts "Logical interconnect #{log_int['name']} was retrieved sucessfully"

puts '#### Update of Internal networks ####'

internal_networks = log_int.list_vlan_networks
puts 'Listing all the internal networks'
internal_networks.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

li_et01_options = {
  vlanId:  '2001',
  purpose:  'General',
  name:  'li_et01',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri: nil,
  type:  'ethernet-networkV3'
}
et01 = OneviewSDK::EthernetNetwork.new(@client, li_et01_options)
et01.create

li_et02_options = {
  vlanId:  '2002',
  purpose:  'General',
  name:  'li_et02',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri: nil,
  type:  'ethernet-networkV3'
}
et02 = OneviewSDK::EthernetNetwork.new(@client, li_et02_options)
et02.create

puts "\nUpdating internal networks"
log_int.update_internal_networks(et01, et02)

internal_networks2 = log_int.list_vlan_networks
puts 'Listing all the internal networks again'
internal_networks2.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

puts "\nReturning to initial state"
log_int.update_internal_networks

internal_networks3 = log_int.list_vlan_networks
puts 'Listing all the internal networks one more time'
internal_networks3.each do |net|
  puts "Network #{net[:name]} with uri #{net[:uri]}"
end

et01.delete
et02.delete

puts "\n\n#### Updating Ethernet Settings ####"
puts "Current:"
puts "igmpIdleTimeoutInterval: #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval: #{log_int['ethernetSettings']['macRefreshInterval']}"


#Backing up
eth_set_backup = {}
eth_set_backup['igmpIdleTimeoutInterval'] = log_int['ethernetSettings']['igmpIdleTimeoutInterval']
eth_set_backup['macRefreshInterval'] = log_int['ethernetSettings']['macRefreshInterval']

log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = 222
log_int['ethernetSettings']['macRefreshInterval'] = 15

puts "\nChanging:"
puts "igmpIdleTimeoutInterval to #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval to #{log_int['ethernetSettings']['macRefreshInterval']}"

puts "\nUpdating internet settings"
log_int.update_ethernet_settings
log_int.retrieve! # Retrieving to guarantee the remote is updated

puts "\nNew Ethernet Settings:"
puts "igmpIdleTimeoutInterval: #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval: #{log_int['ethernetSettings']['macRefreshInterval']}"


puts "\nRolling back..."
eth_set_backup.each do |k,v|
  log_int['ethernetSettings'][k] = v
end
log_int.update_ethernet_settings
log_int.retrieve! # Retrieving to guarantee the remote is updated
puts "igmpIdleTimeoutInterval: #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval: #{log_int['ethernetSettings']['macRefreshInterval']}"

### Update Settings ###
puts 'Updating Logical Interconnect settings'
log_int.update_settings
puts 'Settings updated successfully'

### Instance compliance ###
puts "Putting #{log_int['name']} in compliance with the LIG"
log_int.compliance
puts 'Compliance update successful'
