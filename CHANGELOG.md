## v5.0.0 (Unreleased)

#### Features supported
This release adds support to OneView Rest API version 500 for the hardware variants C7000 and Synergy to the already existing features:
   - Connection Template
   - Datacenter
   - Drive Enclosure
   - Enclosure
   - Enclosure Group
   - Ethernet Network
   - Event
   - Fabric
   - FC Network
   - FCoE Network
   - Firmware Bundle
   - Firmware Driver
   - ID Pool
   - Interconnect
   - Internal Link Set
   - Logical Downlink
   - Logical Enclosure
   - Logical Interconnect
   - Logical Interconnect Group
   - Logical Switch
   - Logical Switch Group
   - Managed SANs
   - Network Set
   - Power Device
   - OS Deployment Plan
   - Rack
   - SAN Manager
   - SAS Interconnect
   - SAS Logical Interconnect
   - SAS Logical Interconnect Group
   - Scopes
   - Server Hardware
   - Server Hardware Type
   - Server Profile Template
   - Storage Pool
   - Storage System
   - Switches
   - Unmanaged Devices
   - Uplink Set
   - User
   - Volume
   - Volume Attachment
   - Volume Templates
   - Web Server Certificate

#### Breaking changes
   1. In the Switch resource, the `statistics` method was fixed, a non-existent endpoint was removed `/rest/switches/statistics/{portName}/subport/{subportNumber}`. Now the method only get statistics of a switch or a specific port.

## v4.5.1

#### Bug fixes & Enhancements
- [#241](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/241) Wrong method name in Server Profile

## v4.5.0

#### New Resources:
   - Event
   - ID Pools

#### Bug fixes & Enhancements
- [#235](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/235) Example file for Synergy LIG fails with 'Interconnect type or Logical Downlink not found!'

## v4.4.0

#### Bug fixes & Enhancements
- [#216](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/216) Missing support for Q ports in API300::Synergy::LIGUplinkSet, missing support for multiple Synergy frames
- [#228](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/228) Method add_uplink for LIG Uplinks Set does not work with Q ports nor integer ports
- [#231](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/#231) Support id in ServerProfile#add_connection

## v4.3.0

#### New Features:
- Added SCMB module and CLI command

#### Bug fixes & Enhancements:
- [#222](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/222) Error listing the OS Deployment Plans from OneView

# v4.2.0

#### New Resources:
   - OS Deployment Plan

#### Bug fixes & Enhancements:
- [#89](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/89) Fix like? method for Logical Interconnect Groups
- [#119](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/112) VolumeAttachment::remove_extra_unmanaged_volume throw Unexpected Http Error
- [#125](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/125) References to resources C7000 in Synergy integration tests
- [#189](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/189) Use helper methods of Rest module for upload and download file
- [#201](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/201) Code to search the collection of resources (paginated search) is repeated in some resources
- [#202](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/202) The method #get_default_settings in LogicalInterconnectGroup is used on integration test
- [#212](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/212) Unable to create a Server Profile with Deployment Plan settings
- [#219](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/219) Fix like? method for Server Profile

#### Design changes:
   - Architecture for future API500 support. Features for API500 are not yet supported.

## v4.1.0

#### New Resources:
Added full support to Image Streamer Rest API version 300:
   - Artifact Bundle
   - Build Plan
   - Deployment Group
   - Deployment Plan
   - Golden Image
   - OS Volume
   - Plan Script

#### Bug fixes & Enhancements:
- Give custom exception classes a data attribute for more error context and default message
- [#116](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/112) VolumeAttachment::remove_extra_unmanaged_volume throw Unexpected Http Error
- [#135](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/135) Firmware Bundle timeout does not give proper instructions for user post failure
- [#146](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/146) Why is Switch the only resource that directly implements #set_scope_uris?
- [#166](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/166) I3S - Simplify login to i3s through oneview client
- [#178](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/178) Add client destroy_session method and domain attribute
- [#174](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/174) I3S - Integration test for Build Plan failing
- [#176](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/176) OneviewSDK.resource_named now finds resources that are not children of Resource
- [#183](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/183) Image Streamer Client cannot be created with the OneView environment variables
- [#184](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/184) Coveralls badge showing coverage as unknown
- [#196](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/196) Missing endpoint for extract backup in Artifact Bundle

# v4.0.0

#### Breaking changes:
- [#93](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/93) Fixed Logical Switch refresh conflict
- [#134](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/134) Remove API300::Synergy::LogicalSwitchGroup resource, which is not defined in the API

#### Bug fixes & Enhancements:
- [#131](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/131) Unavailable methods can take any number of arguments
- [#132](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/132) Made get_default_settings in API200 a class method instead of an instance method
- [#141](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/141) Fixes for API300::Synergy::LogicalInterconnectGroup
- [#142](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/142) EnclosureGroup should raise error in `#add_logical_interconnect_group` if LIG could not be retrieved
- [#145](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/145) REST methods now handle redirects
- [#147](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/147) [API300] Missing #patch in Logical Switch
- [#149](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/149) API300::EnclosureGroup resources support enclosureIndex in interconnectBayMappings
- [#152](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/152) Update client logger's log level with `client.log_level=`
- [#161](https://github.com/HewlettPackard/oneview-sdk-ruby/issues/161) Allow client attributes to be set after initialization, and token to be refreshed
- Client #get_all method now supports an (optional) variant parameter
- Support API modules & variants with the CLI

#### New Resources:
- Scope
- User
- Image Streamer API v300 Resources (experimental):
  - OS Volume
  - Plan Script
  - Artifacts Bundle (unimplemented)
  - Build Plan (unimplemented)
  - Deployment Plan (unimplemented)
  - Golden Image (unimplemented)

## v3.1.0
Added full support to OneView Rest API version 300 for the hardware variants C7000 and Synergy to the already existing features:
   - Interconnect
   - Logical Interconnect
   - Uplink Set
   - Volume attachment
   - Unmanaged devices

#### Bug fixes
- Fixed issue #124 Missing argument in API300 C7000 Managed SAN method.

#### Features supported
- Connection template
- Datacenter
- Enclosure
- Ethernet network
- Fabrics
- FC network
- FCoE network
- Firmware bundles
- Firmware drivers
- Interconnect
- Logical downlink
- Logical enclosure
- Logical interconnect
- Logical interconnect Group
- Uplink Set
- Logical switch
- Logical switch group
- Managed SANs
- Network set
- Power devices
- Racks
- SAN managers
- Server hardware
- Server hardware type
- Server profile
- Server profile template
- Storage pools
- Storage systems
- Switches
- Volume
- Volume attachment
- Volume template
- Drive Enclosures
- Interconnect Link Topology
- Internal Link Set
- SAS Interconnect
- SAS Interconnect Type
- SAS Logical Interconnect
- SAS Logical Interconnect Group
- SAS Logical JBOD Attachments
- SAS Logical JBODs
- Unmanaged devices

# v3.0.0
#### Notes
 This is the Third major version of the Ruby SDK for HPE OneView. It features a split in the API support, allowing for C7000 and Synergy hardware variants to be used, while maintaining compatibility to older versions. There are some code improvements applied throughout the release, as well as additional endpoints support.
 This version of this SDK officially supports OneView appliances version 3.00.00 or higher, using the OneView Rest API version 300.
 Support is provided for C7000 and Synergy enclosure types.

#### Major changes
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
   - Server hardware type
   - Server profile
   - Server profile template
   - Storage pools
   - Storage systems
   - Switches
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

## v2.2.1
 - Fixed issue #88 (firmware bundle file size). Uses multipart-post now

## v2.2.0
 - Added the 'rest' and 'update' commands to the CLI
 - Removed the --force option from the create_from_file CLI command

## v2.1.0
 - Fixed issue with the :resource_named method for OneViewSDK::Resource in Ruby 2.3

# v2.0.0
#### Notes
 This is the second version of the Ruby SDK for HPE OneView. It was given support to the major features of OneView, refactor in some of the already existing code, and also a full set of exceptions to make some common exceptions more explicit in the debugging process.
 This version of this SDK officially supports OneView appliances version 2.00.00 or higher, using the OneView Rest API version 200.
 For now only C7000 enclosure types are being supported.

#### Major changes
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
 3. New exceptions to address the most common issues (Check them in *lib/oneview-sdk/resource/exceptions.rb*)

#### Breaking changes
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

#### Features supported
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
#### Notes
 This is the first release of the OneView SDK in Ruby and it adds full support to some core features listed bellow, with some execeptions that are explicit.
 This version of this SDK supports OneView appliances version 2.00.00 or higher, using the OneView Rest API version 200.
 For now it only supports C7000 enclosure types.


#### Features supported
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

#### Known issues
The integration tests may warn about 3 issues:

1. OneviewSDK::LogicalInterconnect Firmware Updates perform the actions Stage
> The SDK cannot provide Firmware files for your OneView appliance. Please set a valid SPP in your appliance prior to running this test.

2. OneviewSDK::VolumeTemplate#retrieve! retrieves the resource
> OneView 2.00.00 appliances may return the old type of Volume Template resource. Run it against a newer version of OneView and it should not happen.

3. OneviewSDK::VolumeTemplate#update update volume name
> OneView 2.00.00 appliances may return the old type of Volume Template resource. Run it against a newer version of OneView and it should not happen.
