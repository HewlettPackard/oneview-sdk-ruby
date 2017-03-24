# Resources names shared among system test scenarios
class ResourceNames
  class << self
    attr_accessor :ethernet_network
    attr_accessor :bulk_ethernet_network
    attr_accessor :fc_network
    attr_accessor :fcoe_network
    attr_accessor :logical_interconnect_group
    attr_accessor :uplink_set
    attr_accessor :enclosure_group
    attr_accessor :enclosure
    attr_accessor :logical_enclosure
    attr_accessor :logical_interconnect
    attr_accessor :interconnect
    attr_accessor :storage_system
    attr_accessor :storage_pool
    attr_accessor :volume
    attr_accessor :volume_template
    attr_accessor :interconnect_type
  end

  self.ethernet_network = ['EthernetNetwork_01']
  self.bulk_ethernet_network = ['BulkEthernetNetwork']
  self.fc_network = ['FCNetwork_01']
  self.fcoe_network = ['FCoENetwork_01']
  self.logical_interconnect_group = ['LogicalInterconnectGroup_01']
  self.uplink_set = %w(EthernetUplinkSet_01 FCUplinkSet_01)
  self.enclosure_group = %w(EnclosureGroup_01 EnclosureGroup_02)
  self.enclosure = %w(0000A66101 0000A66102 0000A66103)
  self.logical_enclosure = ['LogicalEnclosure_1']
  self.logical_interconnect = ['LogicalEnclosure_1-LogicalInterconnectGroup_01-1']
  self.interconnect = ['0000A66101, interconnect 2', '0000A66101, interconnect 5']
  self.storage_system = ['ThreePAR7200-6710']
  self.storage_pool = ['FST_CPG2']
  self.volume = ['Volume_01']
  self.interconnect_type = ['Virtual Connect SE 16Gb FC Module for Synergy']
end
