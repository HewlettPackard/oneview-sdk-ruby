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

RSpec.shared_examples 'Clean up SystemTestExample C7000' do |context_name|
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
  let(:server_profile_template_class) { OneviewSDK.resource_named('ServerProfileTemplate', api_version, model) }

  # Note: Reverse order of the creating tests

  it 'Removes Server Profile Template' do
    server_profile_template = server_profile_template_class.find_by(current_client, name: C7000ResourceNames.server_profile_template[0]).first
    expect(server_profile_template).to be
    server_profile_template.delete
    expect(server_profile_template.retrieve!).to eq(false)
  end

  it 'Removes Enclosure Groups' do
    eg1 = enclosure_group_class.find_by(current_client, name: C7000ResourceNames.enclosure_group[0]).first
    expect(eg1).to be
    eg1.delete
    expect(eg1.retrieve!).to eq(false)

    eg2 = enclosure_group_class.find_by(current_client, name: C7000ResourceNames.enclosure_group[1]).first
    expect(eg2).to be
    eg2.delete
    expect(eg2.retrieve!).to eq(false)
  end

  it 'Removes Logical interconnect group' do
    lig1 = lig_class.find_by(current_client, name: C7000ResourceNames.logical_interconnect_group[0]).first
    expect(lig1).to be
    lig1.delete
    expect(lig1.retrieve!).to eq(false)
  end
end
