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

require_relative '../_client' # Gives access to @client

# Example: Create/Update/Delete umnanaged device
# NOTE: This will create umnanaged device named 'OneViewSDK Test Unmanaged Device', update it and then delete it.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::UnmanagedDevice
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::UnmanagedDevice
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::UnmanagedDevice
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::UnmanagedDevice
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::UnmanagedDevice

# Resource Class used in this sample
unmanaged_device_class = OneviewSDK.resource_named('UnmanagedDevice', @client.api_version)

device_name = 'OneViewSDK Test Unmanaged Device'
model = 'Unknown'

puts "\nAdding an unmanaged device with name = '#{device_name}'"
item = unmanaged_device_class.new(@client, name: device_name, model: model)
item.add
puts 'Device added:'
puts "- \"#{item['name']}\" with model \"#{item['model']}\" and uri \"#{item['uri']}\""

puts "\nListing all devices:"
unmanaged_devices = unmanaged_device_class.get_devices(@client)
unmanaged_devices.each do |device|
  puts "- \"#{device['name']}\" with model \"#{device['model']}\" and uri \"#{device['uri']}\""
end

puts "\nUpdating device '#{item['name']}'"
item.update(name: item['name'] + ' (Updated)', model: item['model'] + ' (Updated)')
item.refresh
puts 'Device updated:'
puts "- \"#{item['name']}\" with model \"#{item['model']}\" and uri \"#{item['uri']}\""
puts "\nReturning to original name"
item.update(name: device_name, model: model)
item.refresh
puts 'Device updated:'
puts "- \"#{item['name']}\" with model \"#{item['model']}\" and uri \"#{item['uri']}\""

puts "\nRemoving device '#{item['name']}'"
item.remove
puts 'Device removed with success!' unless item.retrieve!
