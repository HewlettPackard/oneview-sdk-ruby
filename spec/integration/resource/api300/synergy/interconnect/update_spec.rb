require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:interconnect) { klass.find_by($client_300_synergy, name: INTERCONNECT1_NAME).first }

  describe '#update' do
    it 'self raises MethodUnavailable' do
      expect { interconnect.update }.to raise_error(/The method #update is unavailable for this resource/)
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
      uplink = OneviewSDK::API300::Synergy::FCNetwork.find_by($client_300_synergy, name: FC_NET_NAME).first
      expect { interconnect.update_port(port['name'], enabled: true, associatedUplinkSetUri: uplink['uri']) }.not_to raise_error
      interconnect.retrieve!
      ports_3 = interconnect['ports'].select { |k| k['portType'] == 'Uplink' }
      port_updated_2 = ports_3.first
      expect(port_updated_2['enabled']).to be true
    end

    it 'fails to update with invalid attributes' do
      port = interconnect[:ports].first
      expect { interconnect.update_port(port['name'], none: 'none') }.to raise_error(/BAD REQUEST/)
    end
  end

  describe '#patch' do
    it 'update a given interconnect across a patch' do
      expect { interconnect.patch('replace', '/uidState', 'Off') }.not_to raise_error
      interconnect.retrieve!
      expect(interconnect['uidState']).to eq('Off')
      expect { interconnect.patch('replace', '/uidState', 'On') }.not_to raise_error
      interconnect.retrieve!
      expect(interconnect['uidState']).to eq('On')
    end
  end
end
