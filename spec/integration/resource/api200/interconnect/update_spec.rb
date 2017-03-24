require 'spec_helper'

klass = OneviewSDK::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:interconnect) { klass.find_by($client, name: 'Encl1, interconnect 1').first }

  describe '#update' do
    it 'raises MethodUnavailable' do
      expect { interconnect.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end
  end

  describe '#resetportprotection' do
    it 'triggers a reset of port protection' do
      expect { interconnect.reset_port_protection }.not_to raise_error
    end
  end

  describe '#update_port' do
    it 'updates with valid attributes' do
      ports = interconnect['ports'].select { |k| k['portType'] == 'Uplink' }
      port = ports.first
      expect { interconnect.update_port(port['name'], enabled: false) }.not_to raise_error
      interconnect.retrieve!
      ports_2 = interconnect['ports'].select { |k| k['portType'] == 'Uplink' }
      port_updated = ports_2.first
      expect(port_updated['enabled']).to be false
      uplink = OneviewSDK::EthernetNetwork.find_by($client, name: ETH_NET_NAME).first
      expect { interconnect.update_port(port['name'], enabled: true, associatedUplinkSetUri: uplink['uri']) }.not_to raise_error
      interconnect.retrieve!
      ports_3 = interconnect['ports'].select { |k| k['portType'] == 'Uplink' }
      port_updated_2 = ports_3.first
      expect(port_updated_2['enabled']).to be true
    end

    it 'fails to update with invalid attributes' do
      port = interconnect[:ports].first
      expect { interconnect.update_port(port['name'], none: 'none') }.to raise_error(OneviewSDK::BadRequest, /BAD REQUEST/)
    end
  end

  describe '#patch' do
    xit 'update a given interconnect across a patch (Skipping this test due to the lack of type of interconnection that supports this operation)' do
      expect { interconnect.patch('replace', '/uidState', 'Off') }.not_to raise_error
      interconnect.retrieve!
      expect(interconnect['uidState']).to eq('Off')
      expect { interconnect.patch('replace', '/uidState', 'On') }.not_to raise_error
      interconnect.retrieve!
      expect(interconnect['uidState']).to eq('On')
    end
  end
end
