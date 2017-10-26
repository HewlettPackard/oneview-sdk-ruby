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

RSpec.shared_examples 'LIGC7000CreateExample' do |context_name|
  include_context context_name
  subject(:item) { described_class.new(current_client, name: LOG_INT_GROUP_NAME) }
  subject(:item_2) { described_class.new(current_client, name: LOG_INT_GROUP2_NAME) }
  subject(:item_3) { described_class.new(current_client, name: LOG_INT_GROUP3_NAME) }
  subject(:item_4) { described_class.new(current_client, name: LOG_INT_GROUP4_NAME) }
  subject(:item_2_state_before_create) { {} }
  let(:ethernet_network) { ethernet_network_class.find_by(current_client, name: ETH_NET_NAME).first }
  let(:fc_network) { fc_network_class.find_by(current_client, name: FC_NET_NAME).first }
  let(:fc_network_2) { fc_network_class.find_by(current_client, name: FC_NET2_NAME).first }
  let(:eth_uplink_options) do
    {
      name: LIG_UPLINK_SET_NAME,
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
  end
  let(:fc_uplink_options) do
    {
      name: LIG_UPLINK_SET2_NAME,
      networkType: 'FibreChannel'
    }
  end
  let(:fc_uplink_options_2) { fc_uplink_options.merge(name: LIG_UPLINK_SET3_NAME) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }
  let(:interconnect_type2) { 'HP VC FlexFabric-20/40 F8 Module' }

  describe '#create' do
    it 'LIG with unrecognized interconnect' do
      expect { item.add_interconnect(1, 'invalid_type') }.to raise_error(OneviewSDK::NotFound, /Interconnect type invalid_type not found!/)
    end

    it 'LIG with interconnect of type HP VC FlexFabric-20/40 F8 Module' do
      item.add_interconnect(1, interconnect_type2)
      item.add_interconnect(2, interconnect_type2)

      eth_lig_uplink_set_1 = lig_uplink_set_class.new(current_client, eth_uplink_options)
      fc_lig_uplink_set_1 = lig_uplink_set_class.new(current_client, fc_uplink_options)
      fc_lig_uplink_set_2 = lig_uplink_set_class.new(current_client, fc_uplink_options_2)

      eth_lig_uplink_set_1.add_network(ethernet_network)
      eth_lig_uplink_set_1.add_uplink(1, 'X1')
      eth_lig_uplink_set_1.add_uplink(1, 'X2')
      item.add_uplink_set(eth_lig_uplink_set_1)

      fc_lig_uplink_set_1.add_network(fc_network)
      fc_lig_uplink_set_1.add_uplink(1, 'D33')
      item.add_uplink_set(fc_lig_uplink_set_1)

      fc_lig_uplink_set_2.add_network(fc_network_2)
      fc_lig_uplink_set_2.add_uplink(2, 'D33')
      item.add_uplink_set(fc_lig_uplink_set_2)

      expect { item.create }.not_to raise_error
      expect(item['uri']).to be
      expect(item['uplinkSets']).to_not be_empty
    end

    it 'LIG with interconnect and uplink sets' do
      item_2.add_interconnect(1, interconnect_type)

      eth_lig_uplink_set_2 = lig_uplink_set_class.new(current_client, eth_uplink_options)

      eth_lig_uplink_set_2.add_network(ethernet_network)
      eth_lig_uplink_set_2.add_uplink(1, 'X1')
      eth_lig_uplink_set_2.add_uplink(1, 'X2')
      item_2.add_uplink_set(eth_lig_uplink_set_2)

      fc_lig_uplink_set = lig_uplink_set_class.new(current_client, fc_uplink_options)
      fc_lig_uplink_set.add_network(fc_network)
      fc_lig_uplink_set.add_uplink(1, 'X3')
      fc_lig_uplink_set.add_uplink(1, 'X4')
      item_2.add_uplink_set(fc_lig_uplink_set)

      item_2_state_before_create.merge!(Marshal.load(Marshal.dump(item_2.data)))

      expect { item_2.create }.not_to raise_error
      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to_not be_empty
    end

    it 'LIG with interconnects' do
      item_3.add_interconnect(1, interconnect_type)
      item_3.add_interconnect(2, interconnect_type)
      expect { item_3.create }.not_to raise_error
      expect(item_3['uri']).to be
      expect(item_3['uplinkSets']).to be_empty
    end

    it 'Empty LIG' do
      expect { item_4.create }.not_to raise_error
      expect(item_4['uri']).to be
    end
  end

  describe '#create!' do
    it 'should retrieve, delete and create the resource' do
      item = described_class.new(current_client, name: LOG_INT_GROUP4_NAME)
      expect { item.create! }.not_to raise_error
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      lig = described_class.new(current_client, name: LOG_INT_GROUP_NAME)
      lig.retrieve!
      expect(lig['uri']).to be
    end
  end

  describe 'getters' do
    it 'default settings' do
      default_settings = described_class.get_default_settings(current_client)
      expect(default_settings).to be
      expect(default_settings['type']).to eq(default_settings_type)
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to match(/ethernetSettings/)
    end

    it 'current settings' do
      item.retrieve! unless item['uri']
      default_settings = item.get_settings
      expect(default_settings).to be
      expect(default_settings['type']).to eq(default_settings_type)
      expect(default_settings['uri']).to_not be
      expect(default_settings['ethernetSettings']['uri']).to match(/ethernetSettings/)
    end
  end

  describe '#like?' do
    context 'when logical interconnect group has interconnect and uplink sets and use "like?" with identical data' do
      it 'should work properly' do
        item_2.retrieve! unless item_2['uri']
        expect(item_2.like?(item_2_state_before_create)).to eq(true)
      end
    end
  end
end
