require_relative '_client' # Gives access to @client

# Example: Create an enclosure group
# NOTE: This will create an enclosure group named 'OneViewSDK Test Enclosure Group', then delete it.
type = 'enclosure group'
options = {
  name: 'OneViewSDK Test Enclosure Group',
  stackingMode: 'Enclosure',
  interconnectBayMappingCount: 8,
  interconnectBayMappings: [
    {
      interconnectBay: 1,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 2,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 3,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 4,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 5,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 6,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 7,
      logicalInterconnectGroupUri: nil
    },
    {
      interconnectBay: 8,
      logicalInterconnectGroupUri: nil
    }
  ],
  type: 'EnclosureGroupV200'
}

item = OneviewSDK::EnclosureGroup.new(@client, options)
item.create
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item2 = OneviewSDK::EnclosureGroup.new(@client, name: options[:name])
item2.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

item.refresh
item.update(name: 'OneViewSDK Test Enclosure_Group')
puts "\nUpdated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."
