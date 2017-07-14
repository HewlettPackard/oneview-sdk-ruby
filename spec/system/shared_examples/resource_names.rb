# Resources names shared among system test scenarios
class ResourceNames
  class << self
    attr_accessor :ethernet_network
    attr_accessor :bulk_ethernet_network
    attr_accessor :fc_network
    attr_accessor :fcoe_network
    attr_accessor :storage_system
    attr_accessor :storage_pool
    attr_accessor :volume
    attr_accessor :volume_template
  end

  self.ethernet_network = ['EthernetNetwork_01']
  self.bulk_ethernet_network = ['BulkEthernetNetwork']
  self.fc_network = ['FCNetwork_01']
  self.fcoe_network = ['FCoENetwork_01']
  self.storage_system = %w(ThreePAR-1 Cluster-1)
  self.storage_pool = %w(CPG-SSD-AO Cluster-1)
  self.volume = %w(Volume_01 VolumeVirtual_01)
  self.volume_template = %w(VolumeTemplate_01 VolumeVirtualTemplate_01)
end
