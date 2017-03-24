require 'tsort'

# For Ordering Integration Tests:
CREATE = 1
UPDATE = 2
DELETE = 3

# Add the necessary methods to make Hash sortable by tsort
class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

DEPENDENCIES = {
  Datacenter: [],
  DriveEnclosure: [:Enclosure],
  Enclosure: [:EnclosureGroup],
  EnclosureGroup: [:LogicalInterconnectGroup, :SASLogicalInterconnectGroup],
  EthernetNetwork: [],
  Fabric: [],
  FCNetwork: [],
  FCoENetwork: [],
  FirmwareBundle: [],
  FirmwareDriver: [:FirmwareBundle],
  Interconnect: [:LogicalInterconnect],
  LIGUplinkSet: [],
  LogicalDownlink: [:Enclosure],
  LogicalEnclosure: [:Enclosure],
  LogicalInterconnect: [:Enclosure, :LogicalEnclosure],
  LogicalInterconnectGroup: [:NetworkSet, :LIGUplinkSet],
  LogicalSwitch: [:LogicalSwitchGroup],
  LogicalSwitchGroup: [],
  ManagedSAN: [:SANManager],
  NetworkSet: [:EthernetNetwork, :FCNetwork, :FCoENetwork],
  OSDeploymentPlan: [],
  PowerDevice: [:ServerProfile, :Volume, :LogicalSwitch],
  Rack: [:ServerProfile],
  SANManager: [],
  SASInterconnect: [:SASLogicalInterconnect],
  SASLogicalInterconnect: [:Enclosure],
  SASLogicalInterconnectGroup: [],
  Scope: [],
  ServerHardware: [:ServerHardwareType],
  ServerHardwareType: [:Enclosure],
  ServerProfile: [:ServerHardware, :Enclosure, :ServerProfileTemplate],
  ServerProfileTemplate: [:EnclosureGroup, :ServerHardware, :Volume],
  StoragePool: [:StorageSystem],
  StorageSystem: [:FCNetwork],
  Switch: [:LogicalSwitch],
  UnmanagedDevice: [],
  UplinkSet: [:LogicalInterconnectGroup, :LogicalInterconnect],
  User: [],
  Volume: [:StorageSystem, :StoragePool, :VolumeTemplate],
  VolumeAttachment: [:ServerProfile],
  VolumeTemplate: [:StoragePool]
}.freeze

SEQ = DEPENDENCIES.tsort
RSEQ = SEQ.reverse

# Get sequence number for the given class (Create sequence)
# @param [Class] klass
# @param [Array] Array with the dependencies
# @return [Integer] sequence number
def seq(klass, seq = SEQ)
  k = klass.to_s.split('::').last.to_sym
  (seq.index(k) || -1) + 1
end

# Get inverse sequence number for the given class (Delete sequence)
# @param [Class] klass
# @param [Array] Array with the dependencies
# @return [Integer] sequence number
def rseq(klass, rseq = RSEQ)
  k = klass.to_s.split('::').last.to_sym
  (rseq.index(k) || -1) + 1
end


# Resource Names:

# BulkEthernetNetwork
BULK_ETH_NET_PREFIX = 'BulkEthernetNetwork'.freeze
BULK_ETH_NET_RANGE = '2-6'.freeze

# EthernetNetwork
ETH_NET_NAME = 'EthernetNetwork_1'.freeze
ETH_NET_NAME_UPDATED = 'EthernetNetwork_1_UPDATED'.freeze

FC_NET_NAME = 'FCNetwork_1'.freeze
FC_NET_NAME_UPDATED = 'FCNetwork_1_UPDATED'.freeze

# FCoENetwork
FCOE_NET_NAME = 'FCoENetwork_1'.freeze
FCOE_NET_NAME_UPDATED = 'FCoENetwork_1_UPDATED'.freeze

# Network Set
NETWORK_SET1_NAME = 'NetworkSet_1'.freeze
NETWORK_SET2_NAME = 'NetworkSet_2'.freeze
NETWORK_SET3_NAME = 'NetworkSet_3'.freeze
NETWORK_SET4_NAME = 'NetworkSet_4'.freeze

# LogicalInterconnectGroup
LOG_INT_GROUP_NAME = 'LogicalInterconnectGroup_1'.freeze
LOG_INT_GROUP_NAME_UPDATED = 'LogicalInterconnectGroup_1_UPDATED'.freeze
LOG_INT_GROUP2_NAME = 'LogicalInterconnectGroup_2'.freeze
LOG_INT_GROUP3_NAME = 'LogicalInterconnectGroup_3'.freeze
LOG_INT_GROUP4_NAME = 'LogicalInterconnectGroup_4'.freeze

# EnclosureGroup
ENC_GROUP_NAME = 'EnclosureGroup_1'.freeze
ENC_GROUP2_NAME = 'EnclosureGroup_2'.freeze
ENC_GROUP3_NAME = 'EnclosureGroup_3'.freeze

# Enclosure
ENCL_HOSTNAME = 'fe80::2:0:9:1%eth2'.freeze
ENCL_NAME = 'Encl1'.freeze
ENCL2_NAME = '0000A66101'.freeze
ENCL3_NAME = '0000A66102'.freeze
ENCL4_NAME = '0000A66103'.freeze
ENCL_NAME_UPDATED = 'Encl1_UPDATED'.freeze

# LogicalEnclosure
LOG_ENCL1_NAME = 'LogicalEnclosure_1'.freeze

# LogicalInterconnect
LOG_INT_NAME = 'Encl1-LogicalInterconnectGroup_1'.freeze
LOG_INT2_NAME = 'LogicalEnclosure_1-LogicalInterconnectGroup_1-1'.freeze

# UplinkSet
UPLINK_SET_NAME = 'EthernetUplinkSet_1'.freeze
UPLINK_SET2_NAME = 'FCUplinkSet_1'.freeze
UPLINK_SET3_NAME = 'FCUplinkSet_2'.freeze
UPLINK_SET4_NAME = 'EthernetUplinkSet_2'.freeze

# LIGUplinkSet
LIG_UPLINK_SET_NAME = 'EthernetUplinkSet_1'.freeze
LIG_UPLINK_SET2_NAME = 'FCUplinkSet_1'.freeze

# storageSystem
STORAGE_SYSTEM_NAME = 'ThreePAR7200-2027'.freeze

# StoragePool
STORAGE_POOL_NAME = 'CPG-SSD-AO'.freeze

# VolumeTemplate
VOL_TEMP_NAME = 'VolumeTemplate_1'.freeze
VOL_TEMP_NAME_UPDATED = 'VolumeTemplate_1_UPDATED'.freeze

# Volume
VOLUME_NAME = 'Volume_1'.freeze
VOLUME2_NAME = 'Volume_2'.freeze
VOLUME3_NAME = 'Volume_3'.freeze
VOLUME4_NAME = 'Volume_4'.freeze
VOL_SNAPSHOT_NAME = 'snapshot_qa'.freeze
VOL_SNAPSHOT2_NAME = 'snapshot_qa_2'.freeze

# Logical Switch Group
LOG_SWI_GROUP_NAME = 'LogicalSwitchGroup_1'.freeze
LOG_SWI_GROUP_NAME_UPDATED = 'LogicalSwitchGroup_1_UPDATED'.freeze

# Logical Switch
LOG_SWI_NAME = 'LogicalSwitch_1'.freeze

# Volume Attachment
VOL_ATTACHMENT_NAME = 'VolumeAttachment_1'.freeze


# Power Device
POW_DEVICE1_NAME = 'PowerDevice_1'.freeze
POW_DEVICE2_NAME = 'PowerDevice_2'.freeze

# Server Profile
SERVER_PROFILE_NAME = 'ServerProfile_1'.freeze
SERVER_PROFILE2_NAME = 'ServerProfile_2'.freeze
SERVER_PROFILE3_NAME = 'ServerProfile_3'.freeze
SERVER_PROFILE4_NAME = 'ServerProfile_4'.freeze
SERVER_PROFILE5_NAME = 'ServerProfile_5'.freeze
SERVER_PROFILE6_NAME = 'ServerProfile_6'.freeze

# Server Profile with OS Deployment Plan
SERVER_PROFILE_WITH_OSDP_NAME = 'ServerProfile_OSDP'.freeze

# Server Profile Template
SERVER_PROFILE_TEMPLATE_NAME = 'ServerProfileTemplate_1'.freeze
SERVER_PROFILE_TEMPLATE_NAME_UPDATED = 'ServerProfileTemplate_1_UPDATED'.freeze

# Datacenter
DATACENTER1_NAME = 'Datacenter_1'.freeze
DATACENTER2_NAME = 'Datacenter_2'.freeze
DATACENTER3_NAME = 'Datacenter_3'.freeze
DATACENTER1_NAME_UPDATED = 'Datacenter_1_UPDATED'.freeze

# Rack
RACK1_NAME = 'Rack_1'.freeze
RACK2_NAME = 'Rack_2'.freeze

# Fabric
DEFAULT_FABRIC_NAME = 'DefaultFabric'.freeze

# Unmanaged Device
UNMANAGED_DEVICE1_NAME = 'UnmanagedDevice_1'.freeze

# FC San Provider
SAN_PROVIDER1_NAME = 'Brocade Network Advisor'.freeze
SAN_PROVIDER2_NAME = 'Cisco'.freeze

# Firmware Driver
FIRMWARE_DRIVER1_NAME = 'CustomSPP_1'.freeze

# SAS Logical Interconnect Group
SAS_LOG_INT_GROUP1_NAME = 'SASLogicalInterconnectGroup_1'.freeze

# SASLogicalInterconnect
SAS_LOG_INT1_NAME = "#{LOG_ENCL1_NAME}-#{SAS_LOG_INT_GROUP1_NAME}-1".freeze

# DriveEnclosure
DRIVE_ENCL1_SERIAL = 'SN123100'.freeze
DRIVE_ENCL1_SERIAL_UPDATED = 'SN123102'.freeze

# Enclosure
ENCLOSURE_1 = '0000A66101'.freeze

# Interconnect
INTERCONNECT_1_NAME = "#{ENCLOSURE_1}, interconnect 3".freeze
INTERCONNECT_2_NAME = "#{ENCL_NAME}, interconnect 1".freeze
INTERCONNECT_3_NAME = "#{ENCLOSURE_1}, interconnect 5".freeze

# SAS Interconnect
SAS_INTERCONNECT1_NAME = "#{ENCLOSURE_1}, interconnect 1".freeze

# USER
USER_NAME = 'TestUser'.freeze

# OS Deployment Plan
OS_DEPLOYMENT_PLAN_NAME = 'HPE - Developer 1.0 - Deployment Test (UEFI)'.freeze
