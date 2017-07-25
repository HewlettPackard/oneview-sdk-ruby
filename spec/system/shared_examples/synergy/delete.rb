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

RSpec.shared_examples 'Clean up SystemTestExample Synergy' do |context_name|
  include_context context_name
  api_version = example.metadata[:api_version]
  model = example.metadata[:model]
  let(:lig_class) { OneviewSDK.resource_named('LogicalInterconnectGroup', api_version, model) }
  let(:enclosure_group_class) { OneviewSDK.resource_named('EnclosureGroup', api_version, model) }
  let(:logical_enclosure_class) { OneviewSDK.resource_named('LogicalEnclosure', api_version, model) }

  # Note: Reverse order of the creating tests

  it 'Logical Enclosure' do
    le = logical_enclosure_class.find_by(current_client, name: SynergyResourceNames.logical_enclosure[0]).first
    expect(le).to be
    le.delete
    expect(le.retrieve!).to eq(false)
  end

  it 'Enclosure Group' do
    eg1 = enclosure_group_class.find_by(current_client, name: SynergyResourceNames.enclosure_group[0]).first
    expect(eg1).to be
    eg1.delete
    expect(eg1.retrieve!).to eq(false)

    eg2 = enclosure_group_class.find_by(current_client, name: SynergyResourceNames.enclosure_group[1]).first
    expect(eg2).to be
    eg2.delete
    expect(eg2.retrieve!).to eq(false)
  end

  it 'Logical interconnect group' do
    lig = lig_class.find_by(current_client, name: SynergyResourceNames.logical_interconnect_group[0]).first
    expect(lig).to be
    lig.delete
    expect(lig.retrieve!).to eq(false)
  end
end
