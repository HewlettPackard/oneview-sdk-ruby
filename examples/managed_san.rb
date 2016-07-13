# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '_client' # Gives access to @client

# List managed SANs for a specified SAN Manager
managed_sans = OneviewSDK::ManagedSAN.find_by(@client, deviceManagerName: @san_manager_ip).each do |san|
  puts "- #{san['name']}"
end

san_01 = managed_sans.last

# Set public attributes
attributes = [
  {
    name: 'MetaSan',
    value: 'Neon SAN',
    valueType: 'String',
    valueFormat: 'None'
  }
]

san_01.set_public_attributes(attributes)
puts "\nPublic attributes updated."

# Set SAN policy
policy = {
  zoningPolicy: 'SingleInitiatorAllTargets',
  zoneNameFormat: '{hostName}_{initiatorWwn}',
  enableAliasing: true,
  initiatorNameFormat: '{hostName}_{initiatorWwn}',
  targetNameFormat: '{storageSystemName}_{targetName}',
  targetGroupNameFormat: '{storageSystemName}_{targetGroupName}'
}
san_01.set_san_policy(policy)
puts "\nSAN policy updated."
