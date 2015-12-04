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
    it 'Invalid network type' do
      options = { networkType: 'N/A' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.to raise_error(/Invalid network type/)
    end
    it 'Ethernet without type' do
      options = { networkType: 'Ethernet' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.to raise_error(/Attribute missing/)
    end
    it 'Ethernet with invalid type' do
      options = { networkType: 'Ethernet', ethernetNetworkType: 'Auto' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.to raise_error(/Invalid ethernet type/)
    end
    it 'Valid Ethernet' do
      options = { networkType: 'Ethernet', ethernetNetworkType: 'Tagged' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.not_to raise_error
    end
    it 'FibreChannel with type' do
      options = { networkType: 'FibreChannel', ethernetNetworkType: 'Tagged' }
      expect { OneviewSDK::LIGUplinkSet.new(@client, options) }.to raise_error(/Attribute not supported/)
    end
  end

  describe 'adds' do
    def_options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
    it 'Add empty network resource' do
      upset = OneviewSDK::LIGUplinkSet.new(@client, def_options)
      net = OneviewSDK::EthernetNetwork.new(@client, {})
      expect { upset.add_network(net) }.to raise_error(/Resource not retrieved from server/)
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
      expect { upset.add_uplink(1, 'V5') }.to raise_error(/Port not supported/)
    end
  end

end
