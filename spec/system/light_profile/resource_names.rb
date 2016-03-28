

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
  end

  self.ethernet_network = ['EthernetNetwork_01']
  self.bulk_ethernet_network = ['BulkEthernetNetwork']
  self.fc_network = ['FCNetwork_01']
  self.fcoe_network = ['FCoENetwork_01']
  self.logical_interconnect_group = ['LogicalInterconnectGroup_01']
  self.uplink_set = ['EthernetUplinkSet_01', 'FCUplinkSet_01']
  self.enclosure_group = ['EcnlosureGroup_01', 'EnclosureGroup_02']
  self.enclosure = ['Encl1']
  self.logical_enclosure = ['Encl1']
  self.logical_interconnect = ['Encl1-LogicalInterconnectGroup_01']
  self.interconnect = ['Encl1, interconnect 1', 'Encl1, interconnect 2']
  self.storage_system = ['ThreePAR7200-2027']
  self.storage_pool = ['CPG-SSD-AO']
  self.volume = ['Volume_01']
  self.volume_template = ['VolumeTemplate_01']

end
