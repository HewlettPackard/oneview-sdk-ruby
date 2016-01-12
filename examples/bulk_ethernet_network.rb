require_relative '_client' # Gives access to @client

# Example: Bulk-Create ethernet networks
# NOTE: This will create 25 ethernet network with prefix name 'OneViewSDK_Bulk_Network'.
options = {
  vlanIdRange: '26-50',
  purpose: 'General',
  namePrefix: 'OneViewSDK_Bulk_Network',
  smartLink: false,
  privateNetwork: false,
  bandwidth: {
    maximumBandwidth: 10_000,
    typicalBandwidth: 2000
  },
  type: 'bulk-ethernet-network'
}

# Creating a bulk ethernet network
bulk_ethernet = OneviewSDK::BulkEthernetNetwork.new(@client, options)
bulk_ethernet.create
puts "Bulk-created ethernet networks '#{bulk_ethernet[:namePrefix]}_<x>' sucessfully."

list = OneviewSDK::EthernetNetwork.get_all(@client).select { |e| e['name'].match(/^OneViewSDK_Bulk_Network_\d*/) }
list.sort_by! { |e| e['name'] }
list.each { |e| puts "  #{e['name']}" }

# Clean up
list.map(&:delete)
puts "\nDeleted all bulk-created ethernet networks sucessfully.\n"
