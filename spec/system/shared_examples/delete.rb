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

RSpec.shared_examples 'Clean up SystemTestExample' do |context_name|
  include_context context_name
  api_version = example.metadata[:api_version]
  model = example.metadata[:model]
  # Resources used in this test
  let(:ethernet_network_class) { OneviewSDK.resource_named('EthernetNetwork', api_version, model) }
  let(:fc_network_class) { OneviewSDK.resource_named('FCNetwork', api_version, model) }
  let(:fcoe_network_class) { OneviewSDK.resource_named('FCoENetwork', api_version, model) }
  let(:storage_pool_class) { OneviewSDK.resource_named('StoragePool', api_version, model) }
  let(:volume_template_class) { OneviewSDK.resource_named('VolumeTemplate', api_version, model) }
  let(:volume_class) { OneviewSDK.resource_named('Volume', api_version, model) }
  let(:scope_class) { OneviewSDK.resource_named('Scope', api_version, model) }

  it 'Scope', if: api_version >= 300 do
    scope = scope_class.find_by(current_client, name: ResourceNames.scope[0]).first
    expect(scope).to be
    network = ethernet_network_class.find_by(current_client, name: ResourceNames.ethernet_network[0]).first
    expect(network).to be

    # it removes network from the scope
    scope.unset_resources(network)
    network.refresh
    expect(network['scopeUris']).to be_empty

    # it deletes scope
    scope.delete
    expect(scope.retrieve!).to eq(false)
  end

  it 'Ethernet Networks' do
    eth1 = ethernet_network_class.find_by(current_client, name: ResourceNames.ethernet_network[0]).first
    expect(eth1).to be
    eth1.delete
    expect(eth1.retrieve!).to eq(false)
  end

  it 'Bulk Ethernet Network' do
    name_prefix = ResourceNames.bulk_ethernet_network[0][:namePrefix]
    vlan_id_range = ResourceNames.bulk_ethernet_network[0][:vlanIdRange]

    # Make better
    network_names = []
    min, max = vlan_id_range.split('-')
    min.upto(max) { |i| network_names << "#{name_prefix}_#{i}" }
    network_names.each do |name|
      network = ethernet_network_class.new(current_client, name: name)
      expect(network.retrieve!).to eq(true)
      expect { network.delete }.not_to raise_error
      expect(network.retrieve!).to eq(false)
    end
  end

  it 'FC Network' do
    fc1 = fc_network_class.find_by(current_client, name: ResourceNames.fc_network[0]).first
    expect(fc1).to be
    fc1.delete
    expect(fc1.retrieve!).to eq(false)
  end

  it 'FCoE Network' do
    fcoe1 = fcoe_network_class.find_by(current_client, name: ResourceNames.fcoe_network[0]).first
    expect(fcoe1).to be
    fcoe1.delete
    expect(fcoe1.retrieve!).to eq(false)
  end

  it 'Volume Template - StoreServ', if: api_version >= 500 do
    volume_template = volume_template_class.find_by(current_client, name: ResourceNames.volume_template[0]).first
    expect(volume_template).to be
    volume_template.delete
    expect(volume_template.retrieve!).to eq(false)
  end

  it 'Volume - StoreServ', if: api_version >= 500 do
    volume = volume_class.find_by(current_client, name: ResourceNames.volume[0]).first
    expect(volume).to be
    volume.delete
    expect(volume.retrieve!).to eq(false)
  end

  it 'Storage Pool', if: api_version >= 500 do
    storage_pool = storage_pool_class.find_by(current_client, name: ResourceNames.storage_pool[0]).first
    expect(storage_pool).to be
    expect(storage_pool['isManaged']).to eq(true)
    expect { storage_pool.manage(false) }.not_to raise_error
    expect(storage_pool['isManaged']).to eq(false)
  end
end
