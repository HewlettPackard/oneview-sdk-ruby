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

require_relative 'c7000_resource_names'
require_relative '../resource_names'

RSpec.shared_examples 'SystemTestExample C7000' do |context_name|
  include_context context_name
  api_version = example.metadata[:api_version]
  model = example.metadata[:model]
  # Resources used in this test
  let(:ethernet_network_class) { OneviewSDK.resource_named('EthernetNetwork', api_version, model) }
  let(:fc_network_class) { OneviewSDK.resource_named('FCNetwork', api_version, model) }
  let(:lig_class) { OneviewSDK.resource_named('LogicalInterconnectGroup', api_version, model) }
  let(:li_class) { OneviewSDK.resource_named('LogicalInterconnect', api_version, model) }
  let(:interconnect_class) { OneviewSDK.resource_named('Interconnect', api_version, model) }
  let(:enclosure_group_class) { OneviewSDK.resource_named('EnclosureGroup', api_version, model) }
  let(:enclosure_class) { OneviewSDK.resource_named('Enclosure', api_version, model) }
  let(:uplink_class) { OneviewSDK.resource_named('UplinkSet', api_version, model) }

  it 'Logical interconnect group' do
    options = {
      name: C7000ResourceNames.logical_interconnect_group[0],
      enclosureType: 'C7000'
    }
    lig1 = lig_class.new(current_client, options)
    lig1.add_interconnect(1, C7000ResourceNames.interconnect_type[0])
    lig1.add_interconnect(3, C7000ResourceNames.interconnect_type[1])
    lig1.create
    expect(lig1['uri']).not_to be_empty
  end

  it 'Enclosure Group' do
    lig = lig_class.new(current_client, name: C7000ResourceNames.logical_interconnect_group[0])
    lig.retrieve!

    options = {
      name: C7000ResourceNames.enclosure_group[0],
      stackingMode: 'Enclosure',
      interconnectBayMappingCount: 8
    }

    eg1 = enclosure_group_class.new(current_client, options)
    eg1.add_logical_interconnect_group(lig)
    eg1.create
    expect(eg1['uri']).not_to be_empty

    options[:name] = C7000ResourceNames.enclosure_group[1]
    eg2 = enclosure_group_class.new(current_client, options)
    eg2.create
    expect(eg2['uri']).not_to be_empty
  end

  xit 'Enclosure' do
    eg1 = enclosure_group_class.new(current_client, name: C7000ResourceNames.enclosure_group[0])
    eg1.retrieve!
    options = {
      enclosureGroupUri: eg1['uri'],
      hostname: $secrets['enclosure1_ip'],
      username: $secrets['enclosure1_user'],
      password: $secrets['enclosure1_password'],
      licensingIntent: 'OneView'
    }
    enc = enclosure_class.new(current_client, options)
    enc.add
    expect(enc['uri']).not_to be_empty
  end

  xit 'Uplink set Ethernet' do

    ethernet = ethernet_network_class.new(current_client, name: ResourceNames.ethernet_network[0])
    ethernet.retrieve!

    enclosure = enclosure_class.new(current_client, name: C7000ResourceNames.enclosure[0])
    enclosure.retrieve!

    li = li_class.new(current_client, name: C7000ResourceNames.logical_interconnect[0])
    li.retrieve!

    interconnect = interconnect_class.new(current_client, name: C7000ResourceNames.interconnect[0])
    interconnect.retrieve!

    options = {
      connectionMode: 'Auto',
      ethernetNetworkType: ethernet['ethernetNetworkType'],
      logicalInterconnectUri: li['uri'],
      manualLoginRedistributionState: 'NotSupported',
      networkType: 'Ethernet',
      name: C7000ResourceNames.uplink_set[0],
      networkUris: [ethernet['uri']]
    }
    uplink = uplink_class.new(current_client, options)
    uplink.add_port_config(
      "#{interconnect['uri']}:Q1.1",
      'Auto',
      [{ value: 1, type: 'Bay' }, { value: enclosure['uri'], type: 'Enclosure' }, { value: 'Q1.1', type: 'Port' }]
    )
    uplink.add_network(ethernet)
    expect { uplink.create }.to_not raise_error
  end

  xit 'Uplink set FC' do
    fc = fc_network_class.new(current_client, name: ResourceNames.fc_network[0])
    fc.retrieve!

    enclosure = enclosure_class.new(current_client, name: C7000ResourceNames.enclosure[0])
    enclosure.retrieve!

    li = li_class.new(current_client, name: C7000ResourceNames.logical_interconnect[0])
    li.retrieve!

    interconnect = interconnect_class.new(current_client, name: C7000ResourceNames.interconnect[1])
    interconnect.retrieve!

    options = {
      connectionMode: 'Auto',
      ethernetNetworkType: 'Tagged',
      logicalInterconnectUri: li['uri'],
      manualLoginRedistributionState: 'Supported',
      networkType: 'FibreChannel',
      name: C7000ResourceNames.uplink_set[1],
      fcNetworkUris: [fc['uri']]
    }
    uplink = uplink_class.new(current_client, options)
    uplink.add_port_config(
      "#{interconnect['uri']}:1",
      'Auto',
      [{ value: 3, type: 'Bay' }, { value: enclosure['uri'], type: 'Enclosure' }, { value: '1', type: 'Port' }]
    )
    uplink.add_fcnetwork(fc)
    expect { uplink.create }.to_not raise_error
  end
end
