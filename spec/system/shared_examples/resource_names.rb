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
    attr_accessor :scope
  end

  self.ethernet_network = ['EthernetNetwork_01']
  self.bulk_ethernet_network = [{ namePrefix: 'BulkEthernetNetwork', vlanIdRange: '2-6' }]
  self.fc_network = ['FCNetwork_01']
  self.fcoe_network = ['FCoENetwork_01']
  self.storage_system = %w(eco-3par ThreePAR-1 Cluster-1)
  self.storage_pool = %w(ESX_Shared_Storage cpg-growth-limit-1TiB CPG-SSD-AO Cluster-1)
  self.volume = %w(Volume_01 VolumeVirtual_01)
  self.volume_template = %w(VolumeTemplate_01 VolumeVirtualTemplate_01)
  self.scope = %w(Scope01)
end
