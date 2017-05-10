require 'spec_helper'

RSpec.describe OneviewSDK::LIGUplinkSet do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::LIGUplinkSet.new(@client_200, networkType: 'FibreChannel')
      expect(item[:logicalPortConfigInfos]).to eq([])
      expect(item[:lacpTimer]).to eq(nil)
      expect(item[:mode]).to eq('Auto')
      expect(item[:networkUris]).to eq([])
    end
  end

  describe 'adds' do
    def_options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
    it 'empty network resource' do
      upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
      net = OneviewSDK::EthernetNetwork.new(@client_200, {})
      expect { upset.add_network(net) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
    end
    it 'retrieved network resource' do
      options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
      upset = OneviewSDK::LIGUplinkSet.new(@client_200, options)
      net = OneviewSDK::EthernetNetwork.new(@client_200, uri: '/rest/ethernet-networks/65546B-A55F20-663390-CA96F5')
      expect { upset.add_network(net) }.not_to raise_error
    end
    context 'statically obtained relative value of' do
      it 'port X7' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'X7') }.not_to raise_error
      end
      it 'port D5' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'D5') }.not_to raise_error
      end
      it 'port 67' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, '67') }.not_to raise_error
      end
      it 'not supported port' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'V5') }.to raise_error(OneviewSDK::InvalidResource, /Port not supported/)
      end
    end
    context 'dynamically obtained relative value of' do
      before :each do
        @type = 'HP VC FlexFabric-20/40 F8 Module'
        resp = { 'portInfos' => [
          { 'portName' => 'Q8:1', 'portNumber' => 97 },
          { 'portName' => 'Q1.1', 'portNumber' => 17 },
          { 'portName' => 'Q1', 'portNumber' => 61 }
          ] }
        allow(OneviewSDK::Interconnect).to receive(:get_type).with(@client_200, @type).and_return(resp)
      end
      it 'port Q8:1' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'Q8:1', @type) }.not_to raise_error
      end
      it 'port Q1' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'Q1', @type) }.not_to raise_error
      end
      it 'port Q1.1' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'Q1.1', @type) }.not_to raise_error
      end
      it 'not existing port' do
        upset = OneviewSDK::LIGUplinkSet.new(@client_200, def_options)
        expect { upset.add_uplink(1, 'Q9:1', @type) }.to raise_error(OneviewSDK::NotFound)
      end
    end
  end
end
