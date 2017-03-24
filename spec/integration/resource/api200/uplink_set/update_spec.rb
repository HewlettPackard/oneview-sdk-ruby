require 'spec_helper'

klass = OneviewSDK::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do

    subject(:uplink) { klass.find_by($client, name: UPLINK_SET4_NAME).first }
    let(:interconnect) { OneviewSDK::Interconnect.find_by($client, name: INTERCONNECT_2_NAME).first }
    let(:enclosure) { OneviewSDK::Enclosure.find_by($client, name: ENCL_NAME).first }
    let(:network) { OneviewSDK::EthernetNetwork.get_all($client).first }
    let(:port) { interconnect['ports'].select { |item| item['portType'] == 'Uplink' && item['pairedPortName'] }.first }

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
      expect(uplink['networkUris']).to be_empty
      uplink.add_network(network)
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['networkUris']).not_to be_empty

      uplink['networkUris'].clear
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['networkUris']).to be_empty
    end
  end
end
