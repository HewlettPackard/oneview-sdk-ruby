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

RSpec.shared_examples 'UplinkSetUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do

    subject(:uplink) { described_class.find_by(current_client, name: UPLINK_SET4_NAME).first }
    let(:log_int) { resource_class_of('LogicalInterconnect').find_by(current_client, name: li_name).first }
    let(:interconnect) { resource_class_of('Interconnect').find_by(current_client, logicalInterconnectUri: log_int['uri']).first }
    let(:network) { resource_class_of('EthernetNetwork').get_all(current_client).first }
    let(:fc_network) { resource_class_of('FCNetwork').find_by(current_client, name: FC_NET3_NAME).first }

    it 'update port_config' do
      port = uplink.get_unassigned_ports.first
      expect(uplink['portConfigInfos']).to be_empty
      uplink.add_port_config(
        port['uri'],
        'Auto',
        [
          { value: port['bayNumber'], type: 'Bay' },
          { value: interconnect['enclosureUri'], type: 'Enclosure' },
          { value: port['portName'], type: 'Port' }
        ]
      )
      expect { uplink.update }.not_to raise_error
      uplink.retrieve!
      expect(uplink['portConfigInfos']).not_to be_empty

      uplink['portConfigInfos'].clear
      expect { uplink.update }.not_to raise_error
      uplink.retrieve!
      expect(uplink['portConfigInfos']).to be_empty
    end

    it 'update network' do
      expect(uplink['networkUris']).to be_empty
      uplink.add_network(network)
      expect { uplink.update }.not_to raise_error
      uplink.retrieve!
      expect(uplink['networkUris']).not_to be_empty

      uplink['networkUris'].clear
      expect { uplink.update }.not_to raise_error
      uplink.retrieve!
      expect(uplink['networkUris']).to be_empty
    end

    it 'update network with fc network' do
      item = described_class.find_by(current_client, name: UPLINK_SET5_NAME).first
      expect(item['fcNetworkUris']).to be_empty
      item.add_fcnetwork(fc_network)
      expect { item.update }.not_to raise_error
      item.retrieve!
      expect(item['fcNetworkUris']).not_to be_empty

      item['fcNetworkUris'].clear
      expect { item.update }.not_to raise_error
      item.retrieve!
      expect(item['fcNetworkUris']).to be_empty
    end
  end
end
