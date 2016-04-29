## Notes
 This is the prerelease of the OneView SDK in Ruby and it adds full support to some core features listed bellow, with some execptions that are explicit.
 The current version of this SDK (v0.1.0) only supports OneView appliances version 2.00.00 or higher, using the OneView Rest API version 200.
 For now it only supports C7000 enclosure types.


## Features supported
- Ethernet Network
- FC Network
- FCoE Network
- Interconnect
- Logical Interconnect
- Logical Interconnect Group
- Uplink Set
- Enclosure
- Logical Enclosure
- Enclosure Group
- Firmware Bundle
- Firmware Driver
- Storage System
- Storage Pool
- Volume
- Volume Template
- Server Profile (CRUD supported)
- Server Profile Template (CRUD supported)
- Server Hardware (CRUD Supported)

## Know Issues
The integration tests may warn about 3 issues:
1. OneviewSDK::LogicalInterconnect Firmware Updates perform the actions Stage
> The SDK cannot provide Firmware files for your OneView appliance. Please set a valid SPP in your appliance prior to running this test.

2. OneviewSDK::VolumeTemplate#retrieve! retrieves the resource
> OneView 2.00.00 appliances may return the old type of Volume Template resource. Run it against a newer version of OneView and it should not happen.

3. OneviewSDK::VolumeTemplate#update update volume name
> OneView 2.00.00 appliances may return the old type of Volume Template resource. Run it against a newer version of OneView and it should not happen.
