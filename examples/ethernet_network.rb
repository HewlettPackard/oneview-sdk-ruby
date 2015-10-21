require 'pry'
require 'json'
require_relative './../lib/oneview-sdk-ruby'

profile_data = {
  'type' => 'ServerProfileV4',
  'uri' => '/rest/server-profiles/1c5e807d-acbe-4ee8-868b-2fb0b6504474',
  'name' => 'chef-web01',
  'serialNumber' => 'VCGE9KB041',
  'serverHardwareUri' => '/rest/server-hardware/31363636-3136-584D-5132-333230314D38',
  'serverHardwareTypeUri' => '/rest/server-hardware-types/2947DC35-BE48-4075-A3FD-254A9B42F5BD',
  'enclosureGroupUri' => '/rest/enclosure-groups/3a11ccdd-b352-4046-a568-a8b0faa6cc39',
  'enclosureUri' => '/rest/enclosures/09SGH236PMVW',
  'category' => 'server-profiles',
  'status' => 'OK',
  'state' => 'Normal',
  'connections' => [{ 'id' => 1, 'name' => 'Altair PXE 1133', 'networkUri' => '/rest/ethernet-networks/02b0b5c3-1a0a-4d5f-b5c9-0c7532cb1e5e' }]
}

client = OneviewSDK::Client.new


# Example 1: Using a resource class
# The resource class can be the one defined in the SDK
# or one define in chef oneview project, as long as it
# responds to the methods used by the client
resource = OneviewSDK::EthernetNetwork.new(
  purpose: 'General',
  name: 'vlan_01',
  type: 'EthernetNetwork',
  vlanId: 10
)

client.create(resource)
puts "  Resource name: #{resource.name}"
puts "  Resource type: #{resource.type}"



# Example 2: Showing other rest-type methods for all resources
# Yes, I know, it's putting profile data into a network, but same idea; there's just not a profile resource yet.
profile = OneviewSDK::EthernetNetwork.new(profile_data)
profile.client = client
profile.create
puts "  Resource name: #{profile.name}"
puts "  Resource type: #{profile.type}"
