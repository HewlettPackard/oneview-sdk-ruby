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

RSpec.shared_examples 'InterconnectUpdateExample' do |context_name|
  include_context context_name

  let(:item) do
    described_class.get_all(current_client).find do |resource|
      !resource['ports'].select { |k| k['portType'] == 'Uplink' }.empty?
    end
  end

  describe '#update' do
    it 'self raises MethodUnavailable' do
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end
  end

  describe '#resetportprotection' do
    it 'triggers a reset of port protection' do
      expect { item.reset_port_protection }.not_to raise_error
    end
  end

  describe '#update_port' do
    it 'updates with valid attributes' do
      raise 'must there is some interconnect with free uplink ports' unless item
      ports = item['ports'].select { |k| k['portType'] == 'Uplink' }
      port = ports.first
      expect { item.update_port(port['name'], enabled: false) }.not_to raise_error
      item.retrieve!
      ports_2 = item['ports'].select { |k| k['portType'] == 'Uplink' }
      port_updated = ports_2.first
      expect(port_updated['enabled']).to be false
      uplink = ethernet_class.find_by(current_client, name: ETH_NET_NAME).first
      expect { item.update_port(port['name'], enabled: true, associatedUplinkSetUri: uplink['uri']) }.not_to raise_error
      item.retrieve!
      ports_3 = item['ports'].select { |k| k['portType'] == 'Uplink' }
      port_updated_2 = ports_3.first
      expect(port_updated_2['enabled']).to be true
    end

    it 'fails to update with invalid attributes' do
      port = item[:ports].first
      expect { item.update_port(port['name'], none: 'none') }.to raise_error(OneviewSDK::BadRequest, /BAD REQUEST/)
    end
  end

  describe '#configuration' do
    it 'applies or re-applies the current interconnect configuration.' do
      expect { item.configuration }.not_to raise_error
    end
  end

  describe '#patch' do
    xit 'update a given interconnect across a patch (Skipping this test due to the lack of type of interconnection that supports this operation)' do
      expect { item.patch('replace', '/uidState', 'Off') }.not_to raise_error
      item.retrieve!
      expect(item['uidState']).to eq('Off')
      expect { item.patch('replace', '/uidState', 'On') }.not_to raise_error
      item.retrieve!
      expect(item['uidState']).to eq('On')
    end
  end
end
