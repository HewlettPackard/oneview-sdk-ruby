# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../../_client' # Gives access to @client

pool_type = 'vmac'

# Example: Actions with pools
item = OneviewSDK::API300::C7000::IDPool.new(@client)

puts "\nGetting a pool of the type IPV4"
item.get_pool('ipv4')
puts "\nPool of the type IPV4 found. \nName: '#{item['name']}' \nURI: '#{item['uri']}' \nRange URI: '#{item['rangeUris']}'"

puts "\nGetting a pool of the type VMAC"
item.get_pool('vmac')
puts "\nPool of the type VMAC found. \nName: '#{item['name']}' \nURI: '#{item['uri']}' \nRange URI: '#{item['rangeUris']}'"

puts "\nGetting a pool of the type VSN"
item.get_pool('vsn')
puts "\nPool of the type VSN found. \nName: '#{item['name']}' \nURI: '#{item['uri']}' \nRange URI: '#{item['rangeUris']}'"

puts "\nGetting a pool of the type VWWN"
item.get_pool('vwwn')
puts "\nPool of the type VWWN found. \nName: '#{item['name']}' \nURI: '#{item['uri']}' \nRange URI: '#{item['rangeUris']}'"

puts "\nDisabling a pool"
item.get_pool(pool_type)
item['enabled'] = false
item.update
item.get_pool(pool_type)
puts "\nPool disabled successfully. \nName: '#{item['name']}' \nEnabled: '#{item['enabled']}'"

puts "\nEnabling a pool"
item.get_pool(pool_type)
item['enabled'] = true
item.update
item.get_pool(pool_type)
puts "\nPool enabled successfully. \nName: '#{item['name']}' \nEnabled: '#{item['enabled']}'"

puts "\nAllocating 2 IDs"
response1 = item.allocate_count(pool_type, 2)
puts "IDs allocated successfully. \n \nQuantity: '#{response1['count']}' \nID List: '#{response1['idList']}'"

# Using the #generate_random_range method to get IDs and allocate them
range = item.generate_random_range(pool_type)
id1 = range['startAddress']
id2 = range['endAddress']
puts "\nAllocating a list of IDs: List: #{id1} and #{id2}"
response2 = item.allocate_id_list(pool_type, id1, id2)
puts "IDs allocated successfully. \n \nQuantity: '#{response2['count']}' \nID List: '#{response2['idList']}'"

puts "\nRemoving the list of the IDs allocated. List: #{response1['idList']}"
response3 = item.collect_ids(pool_type, response1['idList'])
puts "The list of the pools #{response3['idList']} removed successfully."

puts "\nChecking the range availability. Range: 'A2:32:C3:D0:00:00' - 'A2:32:C3:DF:FF:FF'"
response5 = item.check_range_availability(pool_type, response3['idList'])
puts "\nThe range #{response5} is available."

puts "\nRemoving the list of the IDs allocated. List: #{response2['idList']}"
response4 = item.collect_ids(pool_type, response2['idList'])
puts "The list of the pools #{response4['idList']} removed successfully."

puts "\nValidating a list of IDs. List: #{[id1, id2]}"
is_valid = item.validate_id_list(pool_type, id1, id2)
if is_valid
  puts "\nThe list #{[id1, id2]} is valid."
else
  puts "\nThe list #{[id1, id2]} is not valid."
end
