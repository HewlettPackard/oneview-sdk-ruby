require_relative '_client' # Gives access to @client

# Example: Create an bulk ethernet network
# NOTE: This will create a bulk ethernet network with prefix name 'TestNetwork'.
options = {
  vlanIdRange: '1-500',
  purpose: 'General',
  namePrefix: 'TestNetwork',
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
puts "\nCreated bulk-ethernet-network '#{bulk_ethernet[:namePrefix]}' sucessfully.\n"
