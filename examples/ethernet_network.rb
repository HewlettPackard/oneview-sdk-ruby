require_relative '../lib/oneview-sdk-ruby/client'
require_relative '../lib/oneview-sdk-ruby/resource'

client = OneviewSDK::Client.new

# Example 1: Using a resource class
# The resource class can be the one defined in the SDK
# or one define in chef oneview project, as long as it 
# responds to the methods used by the client
resource = OneviewSDK::Resource::EthernetNetwork.new(
  {
    purpose: 'General',
    name: 'vlan_01',
    vlanId: 10
  }
)

client.create_ethernet_network(resource)

# Example 2: Using a struct
Ethernet = Struct.new(:purpose, :name, :vlanId)

ethernet = Ethernet.new('General', 'vlan_01', 10)
client.create_ethernet_network(ethernet)
