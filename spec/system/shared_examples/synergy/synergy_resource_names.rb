# Resources names shared among system test scenarios for Synergy
class SynergyResourceNames
  class << self
    attr_accessor :enclosure
    attr_accessor :enclosure_group
    attr_accessor :interconnect
    attr_accessor :interconnect_type
    attr_accessor :logical_enclosure
    attr_accessor :logical_interconnect
    attr_accessor :logical_interconnect_group
    attr_accessor :uplink_set
  end

  self.enclosure = %w[0000A66101 0000A66102 0000A66103]
  self.enclosure_group = %w[EnclosureGroup_01 EnclosureGroup_02]
  self.interconnect = ['0000A66101, interconnect 2', '0000A66101, interconnect 5']
  self.interconnect_type = ['Virtual Connect SE 40Gb F8 Module for Synergy', 'Virtual Connect SE 16Gb FC Module for Synergy']
  self.logical_enclosure = ['LogicalEnclosure_1']
  self.logical_interconnect = ['LogicalEnclosure_1-LogicalInterconnectGroup_01-1']
  self.logical_interconnect_group = ['LogicalInterconnectGroup_01']
  self.uplink_set = %w[EthernetUplinkSet_01 FCUplinkSet_01]
end
