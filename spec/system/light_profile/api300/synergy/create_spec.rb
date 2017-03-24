# System test script
# Light Profie

require 'spec_helper'
require_relative 'resource_names'

RSpec.describe 'Spin up fluid resource pool API300 Synergy', system: true, sequence: 1 do
  include_context 'system api300 context'

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
    eth1 = OneviewSDK::API300::Synergy::EthernetNetwork.new($client_300_synergy, options)
    eth1.create
    expect(eth1['uri']).not_to be_empty
  end

  it 'Bulk Ethernet Network' do
    bulk_options = {
      vlanIdRange: '2-6',
      purpose: 'General',
      namePrefix: ResourceNames.bulk_ethernet_network[0],
      smartLink: false,
      privateNetwork: false,
      bandwidth: {
        maximumBandwidth: 10_000,
        typicalBandwidth: 2_000
      }
    }
    OneviewSDK::API300::Synergy::EthernetNetwork.bulk_create($client_300_synergy, bulk_options)
  end

  it 'FC Network' do
    options = {
      name: ResourceNames.fc_network[0],
      connectionTemplateUri: nil,
      autoLoginRedistribution: true,
      fabricType: 'FabricAttach'
    }
    fc1 = OneviewSDK::API300::Synergy::FCNetwork.new($client_300_synergy, options)
    fc1.create
    expect(fc1['uri']).not_to be_empty
  end

  it 'FCoE Network' do
    options = {
      name: ResourceNames.fcoe_network[0],
      connectionTemplateUri: nil,
      vlanId: 100
    }
    fcoe1 = OneviewSDK::API300::Synergy::FCoENetwork.new($client_300_synergy, options)
    fcoe1.create
    expect(fcoe1['uri']).not_to be_empty
  end

  it 'Logical interconnect group' do
    options = {
      name: ResourceNames.logical_interconnect_group[0],
      redundancyType: 'Redundant',
      interconnectBaySet: 2,
      enclosureIndexes: [-1]
    }
    lig = OneviewSDK::API300::Synergy::LogicalInterconnectGroup.new($client_300_synergy, options)
    lig.add_interconnect(2, ResourceNames.interconnect_type[0])
    lig.add_interconnect(5, ResourceNames.interconnect_type[0])
    lig['interconnectMapTemplate']['interconnectMapEntryTemplates'].each { |i| i['enclosureIndex'] = -1 }
    lig.create
    expect(lig['uri']).not_to be_empty
  end

  it 'Enclosure Group' do
    lig_options = {
      name: ResourceNames.logical_interconnect_group[0]
    }

    lig = OneviewSDK::API300::Synergy::LogicalInterconnectGroup.new($client_300_synergy, lig_options)
    lig.retrieve!

    options = {
      'name' => ResourceNames.enclosure_group[0],
      'stackingMode' => 'Enclosure',
      'ipAddressingMode' => 'DHCP',
      'type' => 'EnclosureGroupV300',
      'enclosureCount' => 3,
      'interconnectBayMappings' =>
      [
        {
          'enclosureIndex' => 1,
          'interconnectBay' => 2,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 1,
          'interconnectBay' => 5,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 3,
          'interconnectBay' => 2,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 3,
          'interconnectBay' => 5,
          'logicalInterconnectGroupUri' => ''
        }
      ]
    }

    eg1 = OneviewSDK::API300::Synergy::EnclosureGroup.new($client_300_synergy, options)
    eg1['interconnectBayMappings'].each do |bay|
      bay['logicalInterconnectGroupUri'] = lig['uri']
    end
    eg1.add_logical_interconnect_group(lig)
    eg1.create
    expect(eg1['uri']).not_to be_empty
    eg1['interconnectBayMappings'].each do |bay|
      if bay['interconnectBay'] == 2 || bay['interconnectBay'] == 5
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri'])
      else
        expect(bay['logicalInterconnectGroupUri']).to_not be
      end
    end

    options[:name] = ResourceNames.enclosure_group[1]
    eg2 = OneviewSDK::API300::Synergy::EnclosureGroup.new($client_300_synergy, options)
    eg2.create
    expect(eg2['uri']).not_to be_empty
  end

  it 'Logical Enclosure' do
    eg1 = OneviewSDK::API300::Synergy::EnclosureGroup.new($client_300_synergy, name: ResourceNames.enclosure_group[0])
    eg1.retrieve!
    enc1 = OneviewSDK::API300::Synergy::Enclosure.find_by($client_300_synergy, name: ResourceNames.enclosure[0]).first
    enc2 = OneviewSDK::API300::Synergy::Enclosure.find_by($client_300_synergy, name: ResourceNames.enclosure[1]).first
    enc3 = OneviewSDK::API300::Synergy::Enclosure.find_by($client_300_synergy, name: ResourceNames.enclosure[2]).first

    le = OneviewSDK::API300::Synergy::LogicalEnclosure.new($client_300_synergy, name: ResourceNames.logical_enclosure[0])
    le.set_enclosure_group(eg1)
    le.set_enclosures([enc1, enc2, enc3])
    le.create
    result = OneviewSDK::API300::Synergy::LogicalEnclosure.find_by($client_300_synergy, name: ResourceNames.logical_enclosure[0]).first
    expect(result['uri']).to be_truthy
    expect(result['enclosureGroupUri']).to eq(le['enclosureGroupUri'])
    expect(result['enclosureUris']).to eq(le['enclosureUris'])
    expect(result['enclosures'].size).to eq(3)
    expect(result['enclosures'].key?(le['enclosureUris'].first)).to be true
  end

  it 'Storage System' do
    options = {
      credentials: {
        ip_hostname: $secrets_synergy['storage_system1_ip'],
        username: $secrets_synergy['storage_system1_user'],
        password: $secrets_synergy['storage_system1_password']
      },
      managedDomain: 'TestDomain'
    }
    storage = OneviewSDK::API300::Synergy::StorageSystem.new($client_300_synergy, options)
    storage.add
    expect(storage['uri']).not_to be_empty
  end

  it 'Storage Pool' do
    storage_system = OneviewSDK::API300::Synergy::StorageSystem.new($client_300_synergy, name: ResourceNames.storage_system[0])
    storage_system.retrieve!
    expect(storage_system['uri']).not_to be_empty
    options = {
      storageSystemUri: storage_system['uri'],
      poolName: ResourceNames.storage_pool[0]
    }
    storage_pool = OneviewSDK::API300::Synergy::StoragePool.new($client_300_synergy, options)
    storage_pool.add
    expect(storage_pool['uri']).not_to be_empty
  end

  it 'Volume' do
    storage_system = OneviewSDK::API300::Synergy::StorageSystem.new($client_300_synergy, name: ResourceNames.storage_system[0])
    storage_system.retrieve!
    expect(storage_system['uri']).not_to be_empty
    pools = OneviewSDK::API300::Synergy::StoragePool.find_by($client_300_synergy, storageSystemUri: storage_system[:uri])
    storage_pool = pools.first
    options = {
      name: ResourceNames.volume[0],
      description: 'Test volume with common creation: Storage System + Storage Pool',
      provisioningParameters: {
        provisionType: 'Full',
        shareable: true,
        storagePoolUri: storage_pool['uri'],
        requestedCapacity: 512 * 1024 * 1024
      }
    }
    volume = OneviewSDK::API300::Synergy::Volume.new($client_300_synergy, options)
    volume.create
    expect(volume['uri']).not_to be_empty
  end

  it 'Volume Template' do
    options = {
      name: ResourceNames.volume_template[0],
      description: 'Volume Template',
      stateReason: 'None'
    }

    storage_system = OneviewSDK::API300::Synergy::StorageSystem.new($client_300_synergy, name: ResourceNames.storage_system[0])
    storage_system.retrieve!
    sp_options = {
      name: ResourceNames.storage_pool[0],
      storageSystemUri: storage_system['uri']
    }
    storage_pool = OneviewSDK::API300::Synergy::StoragePool.new($client_300_synergy, sp_options)
    storage_pool.retrieve!
    volume_template = OneviewSDK::API300::Synergy::VolumeTemplate.new($client_300_synergy, options)
    volume_template.set_provisioning(true, 'Thin', '10737418240', storage_pool)
    volume_template.set_snapshot_pool(storage_pool)
    volume_template.set_storage_system(storage_system)
    volume_template.create
    expect(volume_template['uri']).not_to be_empty
  end

  it 'Uplink set FC' do
    fc = OneviewSDK::API300::Synergy::FCNetwork.new($client_300_synergy, name: ResourceNames.fc_network[0])
    fc.retrieve!

    enclosure = OneviewSDK::API300::Synergy::Enclosure.new($client_300_synergy, name: ResourceNames.enclosure[0])
    enclosure.retrieve!

    li = OneviewSDK::API300::Synergy::LogicalInterconnect.new($client_300_synergy, name: ResourceNames.logical_interconnect[0])
    li.retrieve!

    interconnect = OneviewSDK::API300::Synergy::Interconnect.new($client_300_synergy, name: ResourceNames.interconnect[1])
    interconnect.retrieve!

    options = {
      type: 'uplink-setV300',
      connectionMode: 'Auto',
      ethernetNetworkType: 'Tagged',
      logicalInterconnectUri: li['uri'],
      manualLoginRedistributionState: 'Supported',
      networkType: 'FibreChannel',
      name: ResourceNames.uplink_set[1],
      fcNetworkUris: [fc['uri']]
    }
    uplink = OneviewSDK::API300::Synergy::UplinkSet.new($client_300_synergy, options)
    uplink.add_port_config(
      "#{interconnect['uri']}:1",
      'Auto',
      [{ value: 2, type: 'Bay' }, { value: enclosure['uri'], type: 'Enclosure' }, { value: '1', type: 'Port' }]
    )
    uplink.add_fcnetwork(fc)
    uplink.create
  end
end
