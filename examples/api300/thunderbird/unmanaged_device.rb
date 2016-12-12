# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../../_client' # Gives access to @client

def print_device(device)
  puts "- \"#{device['name']}\" with model \"#{device['model']}\" and uri \"#{device['uri']}\""
end

puts "\nAdding first device ..."
device1 = OneviewSDK::API300::Thunderbird::UnmanagedDevice.new(@client, name: 'Unmanaged Device 1', model: 'Procurve 4200VL')
device1.add
puts 'Device added:'
print_device(device1)

puts "\nAdding second device ..."
device2 = OneviewSDK::API300::Thunderbird::UnmanagedDevice.new(@client, name: 'Unmanaged Device 2', model: 'Unknown')
device2.add
puts 'Device added:'
print_device(device2)

puts "\nListing all devices:"
unmanaged_devices = OneviewSDK::API300::Thunderbird::UnmanagedDevice.get_devices(@client)
unmanaged_devices.each { |device| print_device(device) }

[device1, device2].each do |device|
  puts "\nUpdating device '#{device['name']}' ..."
  device.update(name: device['name'] + ' (Updated)', model: device['model'] + ' (Updated)')
  device.refresh
  puts 'Device updated:'
  print_device(device)
end

[device1, device2].each do |device|
  puts "\nRemoving device '#{device['name']}' ..."
  puts 'Device removed with success!' if device.remove
end
