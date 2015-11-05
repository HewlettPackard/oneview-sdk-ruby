require_relative '_client' # Gives access to @client

# Example: Create an enclosure group
# NOTE: This will create an enclosure group named ''.
options = {
  name: 'enclosure_group_1',
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

#eg = OneviewSDK::EnclosureGroup.new(@client, options)
#eg.create
#

eg = OneviewSDK::EnclosureGroup.new(@client, name: 'eg_postman')
eg.retrieve!
eg.delete
