# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../_client' # Gives access to @client

# Example: Create a user
# NOTE: This will create a user account named 'testUser', then delete it.
options = {
  userName:  'testUser',
  password: 'secret123',
  emailAddress: 'test_user@example.com',
  fullName: 'Test User',
  roles: ['Read only']
}

# Creating a user
user = OneviewSDK::API200::User.new(@client, options)
user.create
puts "\nCreated user '#{user[:userName]}' sucessfully.\n  uri = '#{user[:uri]}'"

# Find recently created network by userName
matches = OneviewSDK::API200::User.find_by(@client, userName: user[:userName])
user2 = matches.first
puts "\nFound user by userName: '#{user[:userName]}'.\n  uri = '#{user2[:uri]}'"

# Update user settings (password, role, email)
attributes = {
  password: 'secret456',
  emailAddress: 'new_email@example.com',
  fullName: 'New Name',
  roles: ['Network administrator', 'Storage administrator']
}
user2.update(attributes)
puts "\nUpdated user: '#{user2[:userName]}' with new attributes:.\n  #{attributes}"

# Example: List all users with certain attributes
puts "\nUsers with Network administrator role:"
OneviewSDK::API200::User.get_all(@client).each do |u|
  next unless u['roles'].include?('Network administrator')
  puts "  #{u[:userName]}"
end

# Delete this user
user2.delete
puts "\nDeleted user '#{user[:userName]}'."
