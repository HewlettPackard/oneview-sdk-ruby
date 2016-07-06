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
  Enclosure: [:EnclosureGroup],
  EnclosureGroup: [:LogicalInterconnectGroup],
  EthernetNetwork: [],
  Fabric: [],
  FCNetwork: [],
  FCoENetwork: [],
  Interconnect: [:LogicalInterconnect],
  LIGUplinkSet: [],
  LogicalDownlink: [:LogicalInterconnectGroup],
  LogicalEnclosure: [],
  LogicalInterconnect: [:Enclosure],
  LogicalInterconnectGroup: [:NetworkSet, :LIGUplinkSet],
  LogicalSwitch: [:LogicalSwitchGroup],
  LogicalSwitchGroup: [],
  NetworkSet: [:EthernetNetwork, :FCNetwork, :FCoENetwork],
  PowerDevice: [:ServerProfile, :Volume, :LogicalSwitch],
  Rack: [:ServerHardware],
  SANManager: [],
  ServerHardware: [],
  ServerHardwareType: [:ServerHardware],
  ServerProfile: [:ServerHardwareType, :Enclosure, :ServerProfileTemplate],
  ServerProfileTemplate: [:EnclosureGroup, :ServerHardwareType],
  StoragePool: [:StorageSystem],
  StorageSystem: [],
  Switch: [:LogicalSwitch],
  UnmanagedDevice: [],
  UplinkSet: [:LogicalInterconnectGroup],
  Volume: [:StorageSystem, :StoragePool, :VolumeTemplate],
  VolumeAttachment: [:ServerProfile],
  VolumeTemplate: [:StorageSystem, :StoragePool]
}.freeze

SEQ = DEPENDENCIES.tsort
RSEQ = SEQ.reverse

# Get sequence number for the given class (Create sequence)
# @param [Class] klass
# @return [Integer] sequence number
def seq(klass)
  k = klass.to_s.split('::').last.to_sym
  (SEQ.index(k) || -1) + 1
end

# Get inverse sequence number for the given class (Delete sequence)
# @param [Class] klass
# @return [Integer] sequence number
def rseq(klass)
  k = klass.to_s.split('::').last.to_sym
  (RSEQ.index(k) || -1) + 1
end


# Resource Names:

# BulkEthernetNetwork
BULK_ETH_NET_PREFIX = 'BulkEthernetNetwork'.freeze
BULK_ETH_NET_RANGE = '1-5'.freeze

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

# EnclosureGroup
ENC_GROUP_NAME = 'EnclosureGroup_1'.freeze
ENC_GROUP2_NAME = 'EnclosureGroup_2'.freeze
ENC_GROUP3_NAME = 'EnclosureGroup_3'.freeze

# Enclosure
ENCL_NAME = 'Encl1'.freeze
ENCL_NAME_UPDATED = 'Encl1_UPDATED'.freeze

# LogicalInterconnect
LOG_INT_NAME = 'Encl1-LogicalInterconnectGroup_1'.freeze

# UplinkSet
UPLINK_SET_NAME = 'EthernetUplinkSet_1'.freeze
UPLINK_SET2_NAME = 'FCUplinkSet_1'.freeze
UPLINK_SET3_NAME = 'EthernetUplinkSet_2'.freeze

# LIGUplinkSet
LIG_UPLINK_SET_NAME = 'EthernetUplinkSet_1'.freeze
LIG_UPLINK_SET2_NAME = 'EthernetUplinkSet_2'.freeze

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

# Server Profile
SERVER_PROFILE_NAME = 'ServerProfile_1'.freeze
SERVER_PROFILE2_NAME = 'ServerProfile_2'.freeze
SERVER_PROFILE3_NAME = 'ServerProfile_3'.freeze
SERVER_PROFILE4_NAME = 'ServerProfile_4'.freeze
SERVER_PROFILE5_NAME = 'ServerProfile_5'.freeze
SERVER_PROFILE6_NAME = 'ServerProfile_6'.freeze

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
