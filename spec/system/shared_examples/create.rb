# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative 'resource_names'

RSpec.shared_examples 'SystemTestExample' do |context_name|
  include_context context_name
  api_version = example.metadata[:api_version]
  model = example.metadata[:model]

  # Resources used in this test
  let(:ethernet_network_class) { OneviewSDK.resource_named('EthernetNetwork', api_version, model) }
  let(:fc_network_class) { OneviewSDK.resource_named('FCNetwork', api_version, model) }
  let(:fcoe_network_class) { OneviewSDK.resource_named('FCoENetwork', api_version, model) }
  let(:storage_system_class) { OneviewSDK.resource_named('StorageSystem', api_version, model) }
  let(:storage_pool_class) { OneviewSDK.resource_named('StoragePool', api_version, model) }
  let(:volume_template_class) { OneviewSDK.resource_named('VolumeTemplate', api_version, model) }
  let(:volume_class) { OneviewSDK.resource_named('Volume', api_version, model) }
  let(:scope_class) { OneviewSDK.resource_named('Scope', api_version, model) }

  # Variables
  let(:storage_system) do
    options = { name: ResourceNames.storage_system[0] }
    storage_system_class.find_by(current_client, options).first
  end
  let(:storage_pool) do
    options = { name: ResourceNames.storage_pool[0], storageSystemUri: storage_system['uri'] }
    storage_pool_class.find_by(current_client, options).first
  end
  let(:storage_virtual) { storage_system_class.find_by(current_client, name: ResourceNames.storage_system[1]).first }
  let(:storage_virtual_pool) { storage_pool_class.find_by(current_client, storageSystemUri: storage_virtual['uri'], isManaged: true).first }

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
    eth1 = ethernet_network_class.new(current_client, options)
    eth1.create
    expect(eth1['uri']).not_to be_empty
  end

  it 'Bulk Ethernet Network' do
    bulk_options = {
      vlanIdRange: ResourceNames.bulk_ethernet_network[0][:vlanIdRange],
      purpose: 'General',
      namePrefix: ResourceNames.bulk_ethernet_network[0][:namePrefix],
      smartLink: false,
      privateNetwork: false,
      bandwidth: {
        maximumBandwidth: 10_000,
        typicalBandwidth: 2_000
      }
    }
    ethernet_network_class.bulk_create(current_client, bulk_options)
  end

  it 'FC Network' do
    options = {
      name: ResourceNames.fc_network[0],
      connectionTemplateUri: nil,
      autoLoginRedistribution: true,
      fabricType: 'FabricAttach'
    }
    fc1 = fc_network_class.new(current_client, options)
    fc1.create
    expect(fc1['uri']).not_to be_empty
  end

  it 'FCoE Network' do
    options = {
      name: ResourceNames.fcoe_network[0],
      connectionTemplateUri: nil,
      vlanId: 100
    }
    fcoe1 = fcoe_network_class.new(current_client, options)
    fcoe1.create
    expect(fcoe1['uri']).not_to be_empty
  end

  it 'Storage System - StoreServ' do
    storage = storage_system_class.new(current_client, storage_system_options)
    storage.add
    expect(storage['uri']).not_to be_empty
  end

  it 'Storage System - StoreVirtual', if: api_version >= 500 do
    storage = storage_system_class.new(current_client, storage_virtual_system_options)
    storage.add
    expect(storage['uri']).not_to be_empty
  end

  it 'Storage Pool', if: api_version < 500 do
    options = { storageSystemUri: storage_system['uri'], poolName: ResourceNames.storage_pool[0] }
    pool = storage_pool_class.new(current_client, options)
    pool.add
    expect(pool['uri']).not_to be_empty
  end

  it 'Storage Pool', if: api_version >= 500 do
    expect(storage_pool['isManaged']).to eq(false)
    expect { storage_pool.manage(true) }.not_to raise_error
    expect(storage_pool['isManaged']).to eq(true)
  end

  it 'Volume Template', if: api_version < 500 do
    options = {
      name: ResourceNames.volume_template[0],
      description: 'Volume Template',
      stateReason: 'None'
    }

    volume_template = volume_template_class.new(current_client, options)
    volume_template.set_provisioning(true, 'Thin', '10737418240', storage_pool)
    volume_template.set_snapshot_pool(storage_pool)
    volume_template.set_storage_system(storage_system)
    volume_template.create
    expect(volume_template['uri']).not_to be_empty
  end

  it 'Volume Template - StoreServ', if: api_version >= 500 do
    root_template = volume_template_class.find_by(current_client, isRoot: true, family: 'StoreServ').first
    options = { name: ResourceNames.volume_template[0], description: 'Volume Template' }
    volume_template = volume_template_class.new(current_client, options)
    volume_template.set_root_template(root_template)
    volume_template.set_default_value('storagePool', storage_pool)
    volume_template.set_default_value('snapshotPool', storage_pool)
    volume_template.create
    expect(volume_template['uri']).not_to be_empty
  end

  it 'Volume Template - StoreVirtual', if: api_version >= 500 do
    root_template = volume_template_class.find_by(current_client, isRoot: true, family: 'StoreVirtual').first
    options = { name: ResourceNames.volume_template[1], description: 'Volume Template virtual' }
    volume_template = volume_template_class.new(current_client, options)
    volume_template.set_root_template(root_template)
    volume_template.set_default_value('storagePool', storage_virtual_pool)
    volume_template.create
    expect(volume_template['uri']).not_to be_empty
  end

  it 'Volume', if: api_version < 500 do
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
    volume = volume_class.new(current_client, options)
    volume.create
    expect(volume['uri']).not_to be_empty
  end

  it 'Volume - StoreServ', if: api_version >= 500 do
    options = {
      properties: {
        name: ResourceNames.volume[0],
        description: 'Volume store serv',
        size: 512 * 1024 * 1024,
        provisioningType: 'Thin',
        isShareable: true
      }
    }
    volume = volume_class.new(current_client, options)
    volume.set_storage_pool(storage_pool)
    volume.create
    expect(volume['uri']).not_to be_empty
  end

  it 'Volume - StoreVirtual', if: api_version >= 500 do
    options = {
      properties: {
        name: ResourceNames.volume[1],
        description: 'Volume store virtual',
        size: 1024 * 1024 * 1024,
        provisioningType: 'Thin',
        dataProtectionLevel: 'NetworkRaid10Mirror2Way'
      }
    }
    volume = volume_class.new(current_client, options)
    volume.set_storage_pool(storage_virtual_pool)
    volume.create
    expect(volume['uri']).not_to be_empty
  end

  it 'Scope', if: api_version >= 300 do
    options = {
      name: ResourceNames.scope[0],
      description: "#{ResourceNames.scope[0]} sample description"
    }
    scope = scope_class.new(current_client, options)
    scope.create
    expect(scope.retrieve!).to eq(true)

    network = ethernet_network_class.new(current_client, name: ResourceNames.ethernet_network[0])
    expect(network.retrieve!).to eq(true)

    # adding network to scope created
    scope.set_resources(network)
    network.refresh
    expect(network['scopeUris']).to match_array([scope['uri']])
  end
end
