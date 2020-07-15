# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# Example: Create/Update/Delete hypervisor cluster profile
# NOTE: This will create a hypervisor cluster profile named 'cluster5', update it and then delete it.
#
# Supported APIs:
# - 800, 1000, 1200, 1600 and 1800

# Supported Variants:
# C700 and Synergy for all API versions mentioned above

# Resource Class used in this sample
hypervisor_cluster_profile_class = OneviewSDK.resource_named('HypervisorClusterProfile', @client.api_version)

options = {
  type: @hypervisor_type,
  name: @hypervisor_cluster_profile_name,
  hypervisorManagerUri: @hypervisor_manager_uri,
  path: @hypervisor_path,
  hypervisorType: @hypervisor_hypervisorType,
  hypervisorHostProfileTemplate: {
    serverProfileTemplateUri: @hypervisor_serverProfileTemplateUri,
    deploymentPlan: {
      deploymentPlanUri: @hypervisor_deploymentPlanUri,
      serverPassword: @hypervisor_server_password
    },
    hostprefix: @hypervisor_host_prefix
  }
}

hcp = hypervisor_cluster_profile_class.new(@client, options)
hcp.create!
puts "\nCreated hypervisor-cluster_profile '#{hcp[:name]}' sucessfully.\n  uri = '#{hcp[:uri]}'"

# Lists all the hypervisor cluster profiles present
puts "\nListing all the available cluster profiles\n"
hypervisor_cluster_profile_class.find_by(@client, {}).each do |profile|
  puts "#{profile['name']} was found."
end

# Find cluster profile by name
hcp_by_name = hypervisor_cluster_profile_class.find_by(@client, name: hypervisor_cluster_profile_class.find_by(@client, {}).first[:name]).first
puts "\nFound hypervisor cluster profile by name: '#{hcp_by_name[:name]}'.\n  uri : '#{hcp_by_name[:uri]}'"

# Update a hypervisor cluster profile
hcp2 = hypervisor_cluster_profile_class.find_by(@client, {}).first
data = { description: 'New Description' }
puts "\nCluster profile description before update : '#{hcp2[:description]}'"
hcp2.update(data)
puts "Cluster profile description after update : '#{hcp2[:description]}'\n"

# Listing compliance details of the previously updated cluster profile
cp = hcp2.compliance_preview
puts "\nCompliance preview details are :\n#{cp}\n"

# Deletes the created hypervisor cluster profile
# Delete method accepts 2 arguments - soft_delete(boolean) and force(boolean) which are optional till API1200
# soft_delete has become mandatory argument in API1600 and force is still optional
# The default values for the arguments is "false"
hcp.delete(true, true)
puts "\nSuccesfully deleted the cluster profile"
