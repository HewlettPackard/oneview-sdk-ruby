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

require_relative '_client' # Gives access to @client

# HP iPDU information
options = {
  username: @hp_ipdu_username,
  password: @hp_ipdu_password,
  hostname: '172.18.8.12'
}

# HP iPDU Discover
teste = OneviewSDK::PowerDevice.discover(@client, options)
puts teste.class
puts teste['name']


# List HP iPDU power connections
puts "\nPower connections for #{ipdu1['name']}:"
ipdu1['powerConnections'].each do |connection|
  puts "- Power connection uri='#{connection['connectionUri']}'"
end

# Deletes power device
ipdu1.remove
puts "\nPower Device was sucessfully removed."
