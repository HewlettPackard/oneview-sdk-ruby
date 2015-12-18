require_relative '_client'

options = {
  name: 'VolTemplate_1',
  description: 'Volume Template',
  stateReason: 'None'
}

# Retrieve storage pool and storage system
storage_pool = OneviewSDK::StoragePool.new(@client, name: 'FST_CPG1')
storage_pool.retrieve!
storage_system = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: '172.18.11.11' })
storage_system.retrieve!

# Create Volume Template
volume_template = OneviewSDK::VolumeTemplate.new(@client, options)
volume_template.set_provisioning(true, 'Thin', '10737418240', storage_pool)
volume_template.set_snapshot_pool(storage_pool)
volume_template.set_storage_system(storage_system)
volume_template.create
puts "\nCreated Volume Template '#{volume_template[:name]}' sucessfully.\n  uri = '#{volume_template[:uri]}'"

# Retrieve created volume template
volume_template_2 = OneviewSDK::VolumeTemplate.new(@client, name: 'VolTemplate_1')
volume_template_2.retrieve!
puts "\nRetrieved Volume Template by name: '#{volume_template_2[:name]}'.\n  uri = '#{volume_template_2[:uri]}'"

# Find recently created volume template by name
matches = OneviewSDK::VolumeTemplate.find_by(@client, name: 'VolTemplate_1')
volume_template_3 = matches.first
puts "\nFound Volume Template by name: '#{volume_template_3[:name]}'.\n  uri = '#{volume_template_3[:uri]}'"

# Delete Volume Template
volume_template_3.delete
puts "\nDeleted Volume Template '#{volume_template_3[:name]}' successfully.\n"
