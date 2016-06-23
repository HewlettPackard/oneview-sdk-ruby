require 'spec_helper'

RSpec.describe OneviewSDK::LIGUplinkSet do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::LIGUplinkSet.new(@client, networkType: 'FibreChannel')
      expect(item[:logicalPortConfigInfos]).to eq([])
      expect(item[:lacpTimer]).to eq('Short')
      expect(item[:mode]).to eq('Auto')
      expect(item[:networkUris]).to eq([])
    end
  end

  describe 'validations' do
    it 'validates ethernetNetworkType' do
      described_class::VALID_ETHERNET_NETWORK_TYPES.each do |i|
        expect { described_class.new(@client, ethernetNetworkType: i) }.not_to raise_error
      end
      expect { described_class.new(@client, ethernetNetworkType: 'Auto') }
        .to raise_error(OneviewSDK::InvalidResource, /Invalid ethernetNetworkType/)
    end
    it 'Invalid network type' do
      options = { networkType: 'N/A' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.to raise_error(OneviewSDK::InvalidResource, /Invalid network type/)
    end
    it 'Ethernet without type' do
      options = { networkType: 'Ethernet' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }
        .to raise_error(OneviewSDK::IncompleteResource, /ethernetNetworkType attribute missing/)
    end
    it 'Valid Ethernet' do
      options = { networkType: 'Ethernet', ethernetNetworkType: 'Tagged' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.not_to raise_error
    end
    it 'FibreChannel with type' do
      options = { networkType: 'FibreChannel', ethernetNetworkType: 'Tagged' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.to raise_error(OneviewSDK::InvalidResource, /Attribute not supported/)
    end
  end

  describe 'adds' do
    def_options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
    it 'Add empty network resource' do
      upset = OneviewSDK::LIGUplinkSet.new(@client, def_options)
      net = OneviewSDK::EthernetNetwork.new(@client, {})
      expect { upset.add_network(net) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
    end
    it 'Add retrieved network resource' do
      options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
      upset = OneviewSDK::LIGUplinkSet.new(@client, options)
      net = OneviewSDK::EthernetNetwork.new(@client, uri: '/rest/ethernet-networks/65546B-A55F20-663390-CA96F5')
      expect { upset.add_network(net) }.not_to raise_error
    end
    it 'Add X7 port' do
      upset = OneviewSDK::LIGUplinkSet.new(@client, def_options)
      expect { upset.add_uplink(1, 'X7') }.not_to raise_error
    end
    it 'Add D5 port' do
      upset = OneviewSDK::LIGUplinkSet.new(@client, def_options)
      expect { upset.add_uplink(1, 'D5') }.not_to raise_error
    end
    it 'Add not supported port' do
      upset = OneviewSDK::LIGUplinkSet.new(@client, def_options)
      expect { upset.add_uplink(1, 'V5') }.to raise_error(OneviewSDK::InvalidResource, /Port not supported/)
    end
  end

end
