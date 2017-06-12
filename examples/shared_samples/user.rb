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

# Example: Create/Update/Delete User
# NOTE: This will create a user account named 'testUser', then delete it.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::User
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::User
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::User
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::User
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::User

# Resource Class used in this sample
user_class = OneviewSDK.resource_named('User', @client.api_version)

user_name = 'testUser'
full_name = 'Test User'

options = {
  userName:  user_name,
  password: 'secret123',
  emailAddress: 'test_user@example.com',
  fullName: full_name,
  roles: ['Read only']
}

puts "\nCreating an user"
user = user_class.new(@client, options)
user.create
puts "\nCreated user '#{user[:userName]}' sucessfully.\n  uri = '#{user[:uri]}'"

puts "\nFind recently created network by userName"
user2 = user_class.find_by(@client, userName: user[:userName]).first
puts "\nFound user by userName: '#{user[:userName]}'.\n  uri = '#{user2[:uri]}'"

puts "\nValidating if an user exists by user name. User Name = '#{user_name}'"
result = user_class.validate_user_name(@client, user_name)
if result
  puts "\nUser already existing for user name = '#{user_name}'."
else
  puts "\nUser non-existent for user name = '#{user_name}'."
end

puts "\nValidating if an user exists by full name. Full Name = '#{full_name}'"
result = user_class.validate_user_name(@client, user_name)
if result
  puts "\nUser already existing for full name = '#{full_name}'."
else
  puts "\n#{user_name} non-existent."
end

puts "\nUpdating the user settings (password, role, email)"
attributes = {
  password: 'secret456',
  emailAddress: 'new_email@example.com',
  fullName: 'New Name',
  roles: ['Network administrator', 'Storage administrator']
}
user2.update(attributes)
puts "\nUpdated user: '#{user2[:userName]}' with new attributes:.\n  #{attributes}"

# Example: List all users with certain attributes
puts "\nListing users with Network administrator role:"
OneviewSDK::API200::User.get_all(@client).each do |u|
  next unless u['roles'].include?('Network administrator')
  puts "  #{u[:userName]}"
end

puts "\nDeleting the user"
user2.delete
puts "\nUser deleted successfully."
