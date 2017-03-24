require 'spec_helper'

klass = OneviewSDK::API300::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do

    subject(:uplink) { klass.find_by($client_300_synergy, name: UPLINK_SET3_NAME).first }
    let(:interconnect) { OneviewSDK::API300::Synergy::Interconnect.find_by($client_300_synergy, name: INTERCONNECT_1_NAME).first }
    let(:enclosure) { OneviewSDK::API300::Synergy::Enclosure.find_by($client_300_synergy, name: ENCLOSURE_1).first }
    let(:fc_network) { OneviewSDK::API300::Synergy::FCNetwork.find_by($client_300_synergy, name: FC_NET_NAME).first }
    let(:port) { interconnect['ports'].select { |item| item['portType'] == 'Uplink' && item['portHealthStatus'] == 'Normal' }.first }

    before do
      expect(uplink.retrieve!).to eq(true)
    end

    it 'update port_config' do
      expect(uplink['portConfigInfos']).to be_empty
      uplink.add_port_config(
        port['uri'],
        'Auto',
        [{ value: port['bayNumber'], type: 'Bay' }, { value: enclosure[:uri], type: 'Enclosure' }, { value: port['portName'], type: 'Port' }]
      )
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['portConfigInfos']).not_to be_empty

      uplink['portConfigInfos'].clear
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['portConfigInfos']).to be_empty
    end

    it 'update network' do
      expect(uplink['fcNetworkUris']).to be_empty
      uplink.add_fcnetwork(fc_network)
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['fcNetworkUris']).not_to be_empty

      uplink['fcNetworkUris'].clear
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['fcNetworkUris']).to be_empty
    end
  end
end
