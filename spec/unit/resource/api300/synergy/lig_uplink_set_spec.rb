require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LIGUplinkSet do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LIGUplinkSet
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::API300::Synergy::LIGUplinkSet.new(@client_300, networkType: 'FibreChannel')
      expect(item[:logicalPortConfigInfos]).to eq([])
      expect(item[:lacpTimer]).to eq(nil)
      expect(item[:mode]).to eq('Auto')
      expect(item[:networkUris]).to eq([])
    end
  end

  describe 'adds' do
    def_options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
    it 'Add empty network resource' do
      upset = OneviewSDK::API300::Synergy::LIGUplinkSet.new(@client_300, def_options)
      net = OneviewSDK::EthernetNetwork.new(@client_300, {})
      expect { upset.add_network(net) }.to raise_error(OneviewSDK::IncompleteResource, /Must set/)
    end
    it 'Add retrieved network resource' do
      options = { networkType: 'Ethernet', ethernetNetworkType: 'NotApplicable' }
      upset = OneviewSDK::API300::Synergy::LIGUplinkSet.new(@client_300, options)
      net = OneviewSDK::EthernetNetwork.new(@client_300, uri: '/rest/ethernet-networks/65546B-A55F20-663390-CA96F5')
      expect { upset.add_network(net) }.not_to raise_error
    end
    it 'Add X7 port' do
      upset = OneviewSDK::API300::Synergy::LIGUplinkSet.new(@client_300, def_options)
      expect { upset.add_uplink(1, 'X7') }.not_to raise_error
    end
    it 'Add D5 port' do
      upset = OneviewSDK::API300::Synergy::LIGUplinkSet.new(@client_300, def_options)
      expect { upset.add_uplink(1, 'D5') }.not_to raise_error
    end
    it 'Add not supported port' do
      upset = OneviewSDK::API300::Synergy::LIGUplinkSet.new(@client_300, def_options)
      expect { upset.add_uplink(1, 'V5') }.to raise_error(OneviewSDK::InvalidResource, /Port not supported/)
    end
  end

end
