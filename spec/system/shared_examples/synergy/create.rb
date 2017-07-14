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

require_relative 'synergy_resource_names'
require_relative '../resource_names'

RSpec.shared_examples 'SystemTestExample Synergy' do |context_name|
  include_context context_name
  api_version = example.metadata[:api_version]
  model = example.metadata[:model]
  let(:fc_network_class) { OneviewSDK.resource_named('FCNetwork', api_version, model) }
  let(:lig_class) { OneviewSDK.resource_named('LogicalInterconnectGroup', api_version, model) }
  let(:li_class) { OneviewSDK.resource_named('LogicalInterconnect', api_version, model) }
  let(:interconnect_class) { OneviewSDK.resource_named('Interconnect', api_version, model) }
  let(:enclosure_group_class) { OneviewSDK.resource_named('EnclosureGroup', api_version, model) }
  let(:enclosure_class) { OneviewSDK.resource_named('Enclosure', api_version, model) }
  let(:logical_enclosure_class) { OneviewSDK.resource_named('LogicalEnclosure', api_version, model) }
  let(:uplink_class) { OneviewSDK.resource_named('UplinkSet', api_version, model) }

  it 'Logical interconnect group' do
    options = {
      name: SynergyResourceNames.logical_interconnect_group[0],
      redundancyType: 'Redundant',
      interconnectBaySet: 2,
      enclosureIndexes: [-1]
    }
    lig = lig_class.new(current_client, options)
    lig.add_interconnect(2, SynergyResourceNames.interconnect_type[1])
    lig.add_interconnect(5, SynergyResourceNames.interconnect_type[1])
    lig['interconnectMapTemplate']['interconnectMapEntryTemplates'].each { |i| i['enclosureIndex'] = -1 }
    lig.create
    expect(lig['uri']).not_to be_empty
  end

  it 'Enclosure Group' do
    lig_options = {
      name: SynergyResourceNames.logical_interconnect_group[0]
    }

    lig = lig_class.new(current_client, lig_options)
    lig.retrieve!

    options = {
      'name' => SynergyResourceNames.enclosure_group[0],
      'stackingMode' => 'Enclosure',
      'ipAddressingMode' => 'DHCP',
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

    eg1 = enclosure_group_class.new(current_client, options)
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

    options[:name] = SynergyResourceNames.enclosure_group[1]
    eg2 = enclosure_group_class.new(current_client, options)
    eg2.create
    expect(eg2['uri']).not_to be_empty
  end

  it 'Logical Enclosure' do
    eg1 = enclosure_group_class.new(current_client, name: SynergyResourceNames.enclosure_group[0])
    eg1.retrieve!
    enc1 = enclosure_class.find_by(current_client, name: SynergyResourceNames.enclosure[0]).first
    enc2 = enclosure_class.find_by(current_client, name: SynergyResourceNames.enclosure[1]).first
    enc3 = enclosure_class.find_by(current_client, name: SynergyResourceNames.enclosure[2]).first

    le = logical_enclosure_class.new(current_client, name: SynergyResourceNames.logical_enclosure[0])
    le.set_enclosure_group(eg1)
    le.set_enclosures([enc1, enc2, enc3])
    le.create
    result = logical_enclosure_class.find_by(current_client, name: SynergyResourceNames.logical_enclosure[0]).first
    expect(result['uri']).to be_truthy
    expect(result['enclosureGroupUri']).to eq(le['enclosureGroupUri'])
    expect(result['enclosureUris']).to eq(le['enclosureUris'])
    expect(result['enclosures'].size).to eq(3)
    expect(result['enclosures'].key?(le['enclosureUris'].first)).to be true
  end

  it 'Uplink set FC' do
    fc = fc_network_class.new(current_client, name: ResourceNames.fc_network[0])
    fc.retrieve!

    enclosure = enclosure_class.new(current_client, name: SynergyResourceNames.enclosure[0])
    enclosure.retrieve!

    li = li_class.new(current_client, name: SynergyResourceNames.logical_interconnect[0])
    li.retrieve!

    interconnect = interconnect_class.new(current_client, name: SynergyResourceNames.interconnect[1])
    interconnect.retrieve!

    options = {
      connectionMode: 'Auto',
      ethernetNetworkType: 'Tagged',
      logicalInterconnectUri: li['uri'],
      manualLoginRedistributionState: 'Supported',
      networkType: 'FibreChannel',
      name: SynergyResourceNames.uplink_set[1],
      fcNetworkUris: [fc['uri']]
    }
    uplink = uplink_class.new(current_client, options)
    uplink.add_port_config(
      "#{interconnect['uri']}:1",
      'Auto',
      [{ value: 2, type: 'Bay' }, { value: enclosure['uri'], type: 'Enclosure' }, { value: '1', type: 'Port' }]
    )
    uplink.add_fcnetwork(fc)
    uplink.create
  end
end
