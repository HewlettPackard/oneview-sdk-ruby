# v3.1.0
 1. Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features:
   - Uplink Set

# v3.0.0
### Notes
 This is the Third major version of the Ruby SDK for HPE OneView. It features a split in the API support, allowing for C7000 and Synergy hardware variants to be used, while maintaining compatibility to older versions. There are some code improvements applied throughout the release, as well as additional endpoints support.
 This version of this SDK officially supports OneView appliances version 3.00.00 or higher, using the OneView Rest API version 300.
 Support is provided for C7000 and Synergy enclosure types.

### Major changes
 1. Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features:
   - Connection template
   - Datacenter
   - Enclosure
   - Ethernet network
   - Fabrics
   - FC network
   - FCoE network
   - Firmware bundles
   - Firmware drivers
   - Logical downlink
   - Logical enclosure
   - Logical interconnect Group
   - Logical switch
   - Logical switch group
   - Managed SANs
   - Network set
   - Power devices
   - Racks
   - SAN managers
   - Server hardware
   - Server profile
   - Server profile template
   - Storage pools
   - Storage systems
   - Switches
   - Uplink Set
   - Volume
   - Volume template
 2. New features added:
   - Drive Enclosures
   - Interconnect Link Topology
   - Internal Link Set
   - SAS Interconnect
   - SAS Interconnect Type
   - SAS Logical Interconnect
   - SAS Logical Interconnect Group
   - SAS Logical JBOD Attachments
   - SAS Logical JBODs
 3. Design changes:
 - Split features into API modules for each hardware variant
 - Fixed/updated/added CLI commands

#### v2.2.1
 - Fixed issue #88 (firmware bundle file size). Uses multipart-post now

### v2.2.0
 - Added the 'rest' and 'update' commands to the CLI
 - Removed the --force option from the create_from_file CLI command

### v2.1.0
 - Fixed issue with the :resource_named method for OneViewSDK::Resource in Ruby 2.3

# v2.0.0
### Notes
 This is the second version of the Ruby SDK for HPE OneView. It was given support to the major features of OneView, refactor in some of the already existing code, and also a full set of exceptions to make some common exceptions more explicit in the debugging process.
 This version of this SDK officially supports OneView appliances version 2.00.00 or higher, using the OneView Rest API version 200.
 For now only C7000 enclosure types are being supported.

### Major changes
 1. Added full support to the already existing features:
   - Server Profile
   - Server Profile Template
   - Server Hardware
 2. New features added:
   - Connection Templates
   - Datacenter
   - Fabrics
   - Logical downlinks
   - Logical switch groups
   - Logical switches
   - Switches
   - SAN managers
   - Managed SANs
   - Network sets
   - Power devices
   - Racks
   - Server hardware types
   - Unmanaged devices
 3. New exceptions to address the most common issues (Check them in *lib/oneview-sdk/resource/exceptions.rb*)

### Breaking changes
 1. Refactored some method names that may cause incompatibility with older SDK versions. Due to the nature of OneView, the `create` and `delete` methods did not fit the physical infrastructure elements like Enclosures, or Switches, so they now have `add` and `remove` methods that act the same as before, but now it leaves no margin to misunderstand that OneView could actually create these resources. They are:
   - Datacenters
   - Enclosure
   - Power devices
   - Racks
   - Storage systems
   - Storage pools
   - Firmware drivers
   - Firmware bundles (Only `add`)
   - SAN managers
   - Server hardwares
   - Server hardware types
   - Switches
   - Unmanaged devices

### Features supported
- Ethernet network
- FC network
- FCOE network
- Network set
- Connection template
- Fabric
- SAN manager
- Managed SAN
- Interconnect
- Logical interconnect
- Logical interconnect group
- Uplink set
- Logical downlink
- Enclosure
- Logical enclosure
- Enclosure group
- Firmware bundle
- Firmware driver
- Storage system
- Storage pool
- Volume
- Volume template
- Datacenter
- Racks
- Logical switch group
- Logical switch
- Switch
- Power devices
- Server profile
- Server profile template
- Server hardware
- Server hardware type
- Unmanaged devices

# v1.0.0
### Notes
 This is the first release of the OneView SDK in Ruby and it adds full support to some core features listed bellow, with some execeptions that are explicit.
 This version of this SDK supports OneView appliances version 2.00.00 or higher, using the OneView Rest API version 200.
 For now it only supports C7000 enclosure types.


### Features supported
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

### Known issues
The integration tests may warn about 3 issues:

1. OneviewSDK::LogicalInterconnect Firmware Updates perform the actions Stage
> The SDK cannot provide Firmware files for your OneView appliance. Please set a valid SPP in your appliance prior to running this test.

2. OneviewSDK::VolumeTemplate#retrieve! retrieves the resource
> OneView 2.00.00 appliances may return the old type of Volume Template resource. Run it against a newer version of OneView and it should not happen.

3. OneviewSDK::VolumeTemplate#update update volume name
> OneView 2.00.00 appliances may return the old type of Volume Template resource. Run it against a newer version of OneView and it should not happen.
