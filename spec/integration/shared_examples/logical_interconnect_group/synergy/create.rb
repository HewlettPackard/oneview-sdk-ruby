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

RSpec.shared_examples 'LIGSynergyCreateExample' do |context_name|
  include_context context_name

  let(:interconnect_type) { 'Virtual Connect SE 40Gb F8 Module for Synergy' }
  let(:interconnect_type2) { 'Virtual Connect SE 16Gb FC Module for Synergy' }

  describe '#create' do
    it 'creates a LIG with interconnect types' do
      lig_default_options = {
        'name' => LOG_INT_GROUP_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 2,
        'enclosureIndexes' => [-1]
      }
      fc_uplink_options = {
        'name' => LIG_UPLINK_SET2_NAME,
        'networkType' => 'FibreChannel'
      }
      fc_network = fc_network_class.find_by(current_client, name: FC_NET_NAME).first

      fc_lig_uplink_set = lig_uplink_set_class.new(current_client, fc_uplink_options)
      fc_lig_uplink_set.add_network(fc_network)

      item = described_class.new(current_client, lig_default_options)
      item.add_interconnect(2, interconnect_type2)
      item.add_interconnect(5, interconnect_type2)
      item.add_uplink_set(fc_lig_uplink_set)
      item['interconnectMapTemplate']['interconnectMapEntryTemplates'].each { |i| i['enclosureIndex'] = -1 }

      expect { item.create }.not_to raise_error
    end

    it 'creates an uplink set and a LIG with internal networks' do
      ethernet_network = ethernet_network_class.find_by(current_client, name: ETH_NET_NAME).first

      lig_default_options = {
        'name' => LOG_INT_GROUP2_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 3
      }
      item = described_class.new(current_client, lig_default_options)
      item.add_interconnect(3, interconnect_type)
      item.add_interconnect(6, interconnect_type)
      item.add_internal_network(ethernet_network)
      expect { item.create }.not_to raise_error
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      lig_default_options = {
        'name' => LOG_INT_GROUP_NAME,
        'redundancyType' => 'Redundant',
        'interconnectBaySet' => 2
      }
      item = described_class.new(current_client, lig_default_options)
      item.retrieve!
      expect(item['uri']).to be
    end
  end

  describe 'getters' do
    it 'gets the default settings' do
      expect { described_class.get_default_settings(current_client) }.not_to raise_error
    end

    it 'gets the current settings' do
      item = described_class.find_by(current_client, name: LOG_INT_GROUP_NAME).first
      expect { item.get_settings }.not_to raise_error
    end
  end
end
