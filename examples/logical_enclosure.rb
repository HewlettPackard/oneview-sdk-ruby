require_relative '_client'

options = {
  name: 'Logical_Enclosure_1',
  enclosureUris: [
    '/rest/enclosures/09SGH100X6J1'
  ],
  enclosureGroupUri: '/rest/enclosure-groups/91ba226b-859e-4a44-8496-f09a31baac9cc',
  firmwareBaselineUri: nil,
  forceInstallFirmware: false
}

# logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client, options)
# logical_enclosure.create


# OneviewSDK::LogicalEnclosure.find_by(@client, {}).first.configuration
# OneviewSDK::LogicalEnclosure.find_by(@client, {}).first.updateFromGroup
# OneviewSDK::LogicalEnclosure.find_by(@client, {}).first.script("")
# dump = {
#  errorCode: 'Mydump',
#  encrypt: false,
#  excludeApplianceDump: false
# }

puts OneviewSDK::LogicalEnclosure.find_by(@client, {}).first.get_script
OneviewSDK::LogicalEnclosure.find_by(@client, {}).first.set_script("teste")
puts 'Script update'
puts OneviewSDK::LogicalEnclosure.find_by(@client, {}).first.get_script
