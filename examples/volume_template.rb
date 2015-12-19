require_relative '_client'

# Example: Create a volume template
# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip

fail 'Must set @storage_system_ip in _client.rb' unless @storage_system_ip

options = {
  name: 'ONEVIEW_SDK_TEST VT1',
  description: 'Volume Template',
  stateReason: 'None'
}

# Retrieve storage pool and storage system
storage_pool = OneviewSDK::StoragePool.find_by(@client, {}).first
fail 'ERROR: No storage pools found!' unless storage_pool
storage_system = OneviewSDK::StorageSystem.find_by(@client, credentials: { ip_hostname: @storage_system_ip }).first
fail "ERROR: Storage System #{@storage_system_ip} not found!" unless storage_system

# Create Volume Template
volume_template = OneviewSDK::VolumeTemplate.new(@client, options)
volume_template.set_provisioning(true, 'Thin', '10737418240', storage_pool)
volume_template.set_snapshot_pool(storage_pool)
volume_template.set_storage_system(storage_system)
volume_template.create
puts "\nCreated Volume Template '#{volume_template[:name]}' sucessfully.\n  uri = '#{volume_template[:uri]}'"

# Retrieve created volume template
volume_template_2 = OneviewSDK::VolumeTemplate.new(@client, name: options[:name])
volume_template_2.retrieve!
puts "\nRetrieved Volume Template by name: '#{volume_template_2[:name]}'.\n  uri = '#{volume_template_2[:uri]}'"

# Find recently created volume template by name
matches = OneviewSDK::VolumeTemplate.find_by(@client, name: options[:name])
volume_template_3 = matches.first
puts "\nFound Volume Template by name: '#{volume_template_3[:name]}'.\n  uri = '#{volume_template_3[:uri]}'"

# Delete Volume Template
volume_template.delete
puts "\nDeleted Volume Template '#{volume_template[:name]}' successfully.\n"
