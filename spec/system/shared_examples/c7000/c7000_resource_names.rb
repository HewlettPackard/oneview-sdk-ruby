# Resources names shared among system test scenarios for C7000
class C7000ResourceNames
  class << self
    attr_accessor :enclosure
    attr_accessor :enclosure_group
    attr_accessor :interconnect
    attr_accessor :interconnect_type
    attr_accessor :logical_enclosure
    attr_accessor :logical_interconnect
    attr_accessor :logical_interconnect_group
    attr_accessor :uplink_set
    attr_accessor :server_hardware_type
    attr_accessor :server_profile_template
  end

  self.enclosure = ['Encl1']
  self.enclosure_group = %w(EnclosureGroup_01 EnclosureGroup_02)
  self.interconnect = ['Encl1, interconnect 1', 'Encl1, interconnect 3']
  self.interconnect_type = ['HP VC FlexFabric-20/40 F8 Module', 'HP VC 16Gb 24-Port FC Module']
  self.logical_enclosure = ['Encl1']
  self.logical_interconnect = ['Encl1-LogicalInterconnectGroup_01']
  self.logical_interconnect_group = ['LogicalInterconnectGroup_01']
  self.uplink_set = %w(EthernetUplinkSet_01 FCUplinkSet_01)
  self.server_hardware_type = ['BL460c Gen8 1', 'BL460c Gen9 1']
  self.server_profile_template = %w(ServerProfileTemplate_01)
end
