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

RSpec.shared_examples 'EnclosureGroupCreateExample' do |context_name, options|
  include_context context_name

  let(:enclosure_group_options) do
    {
      'name' => ENC_GROUP2_NAME,
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
          'enclosureIndex' => 1,
          'interconnectBay' => 3,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 1,
          'interconnectBay' => 6,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 2,
          'interconnectBay' => 3,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 2,
          'interconnectBay' => 6,
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
        },
        {
          'enclosureIndex' => 3,
          'interconnectBay' => 3,
          'logicalInterconnectGroupUri' => ''
        },
        {
          'enclosureIndex' => 3,
          'interconnectBay' => 6,
          'logicalInterconnectGroupUri' => ''
        }
      ]
    }
  end

  describe '#create' do
    it 'can create simple Enclosure Group' do
      item = described_class.new(current_client, name: ENC_GROUP_NAME)
      item.create
      expect(item['name']).to eq(ENC_GROUP_NAME)
    end

    it 'can create EnclosureGroup with LIG', if: options[:variant] == 'C7000' do
      item = described_class.new(current_client, name: ENC_GROUP2_NAME)
      lig = log_inter_group_class.find_by(current_client, name: LOG_INT_GROUP_NAME).first
      item.add_logical_interconnect_group(lig)
      item.create
      expect(item['name']).to eq(ENC_GROUP2_NAME)
      item['interconnectBayMappings'].each do |bay|
        expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 1
        expect(bay['logicalInterconnectGroupUri']).to_not be if bay['interconnectBay'] != 1
      end
    end

    it 'can create EnclosureGroup with LIG', if: options[:variant] == 'Synergy' do
      item = described_class.new(current_client, enclosure_group_options)
      lig = log_inter_group_class.find_by(current_client, 'name' => LOG_INT_GROUP_NAME).first
      lig2 = log_inter_group_class.find_by(current_client, 'name' => LOG_INT_GROUP3_NAME).first
      enclosure_group_options['interconnectBayMappings'].each do |bay|
        bay['logicalInterconnectGroupUri'] = lig['uri'] if bay['interconnectBay'] == 2 || bay['interconnectBay'] == 5
        bay['logicalInterconnectGroupUri'] = lig2['uri'] if bay['interconnectBay'] == 3 || bay['interconnectBay'] == 6
      end

      item.create
      expect(item['name']).to eq(ENC_GROUP2_NAME)
      item['interconnectBayMappings'].each do |bay|
        if bay['interconnectBay'] == 2 || bay['interconnectBay'] == 5
          expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri'])
        elsif bay['interconnectBay'] == 3 || bay['interconnectBay'] == 6
          expect(bay['logicalInterconnectGroupUri']).to eq(lig2['uri'])
        else
          expect(bay['logicalInterconnectGroupUri']).to_not be
        end
      end
    end

    it 'can create EnclosureGroup with LIG on enclosure index specific', if: options[:execute_with_enclosure_index] do
      item = described_class.new(current_client, name: ENC_GROUP3_NAME)
      lig = log_inter_group_class.find_by(current_client, name: LOG_INT_GROUP_NAME).first
      item.add_logical_interconnect_group(lig, 1)
      item.create
      expect(item['name']).to eq(ENC_GROUP3_NAME)
      item['interconnectBayMappings'].each do |bay|
        if options[:variant] == 'C7000'
          expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 1
          expect(bay['logicalInterconnectGroupUri']).to_not be if bay['interconnectBay'] != 1
        else
          expect(bay['logicalInterconnectGroupUri']).to eq(lig['uri']) if bay['interconnectBay'] == 2 || bay['interconnectBay'] == 5
          expect(bay['logicalInterconnectGroupUri']).to_not be if bay['interconnectBay'] != 2 && bay['interconnectBay'] != 5
        end
      end
    end
  end
end
