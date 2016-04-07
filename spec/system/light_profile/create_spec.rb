# System test script
# Light Profie

require_relative '../../spec_helper'

RSpec.describe 'Spin up fluid resource pool', system: true, sequence: 1 do
  include_context 'system context'

  it 'Ethernet Networks' do
    options = {
      name: ResourceNames.ethernet_network[0],
      description: 'Ethernet network',
      ethernetNetworkType: 'Tagged',
      vlanId: 1001,
      purpose: 'General',
      smartLink: true,
      privateNetwork: false
    }
    eth1 = OneviewSDK::EthernetNetwork.new($client, options)
    eth1.create
    expect(eth1['uri']).not_to be_empty
  end

  it 'Bulk Ethernet Network' do
    options = {
      vlanIdRange: '10-14',
      purpose: 'General',
      namePrefix: ResourceNames.bulk_ethernet_network[0],
      smartLink: false,
      privateNetwork: false,
      bandwidth: {
        maximumBandwidth: 10_000,
        typicalBandwidth: 2000
      },
      type: 'bulk-ethernet-network'
    }
    bulk_ethernet = OneviewSDK::BulkEthernetNetwork.new($client, options)
    bulk_ethernet.create
  end

  it 'FC Network' do
    options = {
      name: ResourceNames.fc_network[0],
      connectionTemplateUri: nil,
      autoLoginRedistribution: true,
      fabricType: 'FabricAttach'
    }
    fc1 = OneviewSDK::FCNetwork.new($client, options)
    fc1.create
    expect(fc1['uri']).not_to be_empty
  end

  it 'FCoE Network' do
    options = {
      name: ResourceNames.fcoe_network[0],
      connectionTemplateUri: nil,
      vlanId: 100
    }
    fcoe1 = OneviewSDK::FCoENetwork.new($client, options)
    fcoe1.create
    expect(fcoe1['uri']).not_to be_empty
  end

  it 'Logical interconnect group' do
    options = {
      name: ResourceNames.logical_interconnect_group[0],
      enclosureType: 'C7000'
    }
    lig1 = OneviewSDK::LogicalInterconnectGroup.new($client, options)
    lig1.add_interconnect(1, 'HP VC FlexFabric 10Gb/24-Port Module')
    lig1.add_interconnect(2, 'HP VC FlexFabric 10Gb/24-Port Module')
    lig1.create
    expect(lig1['uri']).not_to be_empty
  end

  it 'Enclosure Group' do
    lig = OneviewSDK::LogicalInterconnectGroup.new($client, name: ResourceNames.logical_interconnect_group[0])
    lig.retrieve!

    options = {
      name: ResourceNames.enclosure_group[0],
      stackingMode: 'Enclosure',
      interconnectBayMappingCount: 8
    }

    eg1 = OneviewSDK::EnclosureGroup.new($client, options)
    eg1.add_logical_interconnect_group(lig)
    eg1.create
    expect(eg1['uri']).not_to be_empty

    options[:name] = ResourceNames.enclosure_group[1]
    eg2 = OneviewSDK::EnclosureGroup.new($client, options)
    eg2.create
    expect(eg2['uri']).not_to be_empty
  end

  it 'Enclosure' do
    eg1 = OneviewSDK::EnclosureGroup.new($client, name: ResourceNames.enclosure_group[0])
    eg1.retrieve!
    options = {
      enclosureGroupUri: eg1['uri'],
      hostname: '172.18.1.11',
      username: 'dcs',
      password: 'dcs',
      licensingIntent: 'OneView'
    }
    enc = OneviewSDK::Enclosure.new($client, options)
    enc.create
    expect(enc['uri']).not_to be_empty
  end

  it 'Storage System' do
    options = {
      credentials: {
        ip_hostname: '172.18.11.11',
        username: 'dcs',
        password: 'dcs'
      },
      managedDomain: 'TestDomain'
    }
    storage = OneviewSDK::StorageSystem.new($client, options)
    storage.create
    expect(storage['uri']).not_to be_empty
  end

  it 'Storage Pool' do
    storage_system = OneviewSDK::StorageSystem.new($client, name: ResourceNames.storage_system[0])
    storage_system.retrieve!
    expect(storage_system['uri']).not_to be_empty
    options = {
      storageSystemUri: storage_system['uri'],
      poolName: 'FST_CPG2'
    }
    storage_pool = OneviewSDK::StoragePool.new($client, options)
    storage_pool.create
    expect(storage_pool['uri']).not_to be_empty
  end

  it 'Volume' do
    options = {
      name: ResourceNames.volume[0],
      description: 'Test volume with common creation: Storage System + Storage Pool'
    }
    volume = OneviewSDK::Volume.new($client, options)
    storage_system = OneviewSDK::StorageSystem.new($client, name: ResourceNames.storage_system[0])
    storage_system.retrieve!
    expect(storage_system['uri']).not_to be_empty
    pools = OneviewSDK::StoragePool.find_by($client, storageSystemUri: storage_system[:uri])
    storage_pool = pools.first
    provisioning_parameters = {
      provisionType: 'Full',
      shareable: true,
      storagePoolUri: storage_pool['uri'],
      requestedCapacity: 512 * 1024 * 1024
    }
    volume.create(provisioning_parameters)
    expect(volume['uri']).not_to be_empty
  end

  it 'Volume Template' do
    options = {
      name: ResourceNames.volume_template[0],
      description: 'Volume Template',
      stateReason: 'None'
    }
    storage_pool = OneviewSDK::StoragePool.find_by($client, {}).first
    storage_system = OneviewSDK::StorageSystem.find_by($client, {}).first
    volume_template = OneviewSDK::VolumeTemplate.new($client, options)
    volume_template.set_provisioning(true, 'Thin', '10737418240', storage_pool)
    volume_template.set_snapshot_pool(storage_pool)
    volume_template.set_storage_system(storage_system)
    volume_template.create
    expect(volume_template['uri']).not_to be_empty
  end

  it 'Uplink set Ethernet' do
    ethernet = OneviewSDK::EthernetNetwork.new($client, name: ResourceNames.ethernet_network[0])
    ethernet.retrieve!

    enclosure = OneviewSDK::Enclosure.new($client, name: ResourceNames.enclosure[0])
    enclosure.retrieve!

    li = OneviewSDK::LogicalInterconnect.new($client, name: ResourceNames.logical_interconnect[0])
    li.retrieve!

    interconnect = OneviewSDK::Interconnect.new($client, name: ResourceNames.interconnect[0])

    options = {
      connectionMode: 'Auto',
      ethernetNetworkType: ethernet['ethernetNetworkType'],
      logicalInterconnectUri: li['uri'],
      manualLoginRedistributionState: 'NotSupported',
      networkType: 'Ethernet',
      name: ResourceNames.uplink_set[0]
    }
    uplink = OneviewSDK::UplinkSet.new($client, options)
    uplink.add_portConfig(
      interconnect['uri'],
      'Auto',
      [{ value: 1, type: 'Bay' }, { value: enclosure['uri'], type: 'Enclosure' }, { value: 'X3', type: 'Port' }]
    )
    uplink.add_network(ethernet)
    uplink.create
  end

  it 'Uplink set FC' do
    fc = OneviewSDK::FCNetwork.new($client, name: ResourceNames.fc_network[0])
    fc.retrieve!

    enclosure = OneviewSDK::Enclosure.new($client, name: ResourceNames.enclosure[0])
    enclosure.retrieve!

    li = OneviewSDK::LogicalInterconnect.new($client, name: ResourceNames.logical_interconnect[0])
    li.retrieve!

    interconnect = OneviewSDK::Interconnect.new($client, name: ResourceNames.interconnect[0])

    options = {
      connectionMode: 'Auto',
      ethernetNetworkType: 'Tagged',
      logicalInterconnectUri: li['uri'],
      manualLoginRedistributionState: 'Supported',
      networkType: 'FibreChannel',
      name: ResourceNames.uplink_set[1]
    }
    uplink = OneviewSDK::UplinkSet.new($client, options)
    uplink.add_portConfig(
      interconnect['uri'],
      'Auto',
      [{ value: 1, type: 'Bay' }, { value: enclosure['uri'], type: 'Enclosure' }, { value: 'X4', type: 'Port' }]
    )
    uplink.add_fcnetwork(fc)
    uplink.create
  end

end
