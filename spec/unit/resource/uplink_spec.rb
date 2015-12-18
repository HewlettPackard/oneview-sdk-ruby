require 'spec_helper'

RSpec.describe OneviewSDK::Uplink do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      profile = OneviewSDK::Uplink.new(@client)
      expect(profile[:type]).to eq('uplink-setV3')
      expect(profile[:portConfigInfos]).to eq([])
      expect(profile[:networkUris]).to eq([])
      expect(profile[:fcNetworkUris]).to eq([])
      expect(profile[:fcoeNetworkUris]).to eq([])
      expect(profile[:primaryPortLocation]).to eq(nil)
    end
  end

  describe 'validations' do
    context 'ethernetNetworkType' do
      it 'validates ethernetNetworkType' do
        uplink = OneviewSDK::Uplink.new(@client)
        values = %w(NotApplicable Tagged Tunnel Unknown Untagged)
        values.each do |value|
          uplink[:ethernetNetworkType] = value
          expect(uplink[:ethernetNetworkType]).to eq(value)
        end
      end

      it 'Incorrect ethernetNetworkType' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink[:ethernetNetworkType] = 'None' }.to raise_error(/Invalid ethernet network type/)
      end
    end

    context 'lacpTimer' do
      it 'validates lacpTimer' do
        uplink = OneviewSDK::Uplink.new(@client)
        values = %w(Long Short)
        values.each do |value|
          uplink[:lacpTimer] = value
          expect(uplink[:lacpTimer]).to eq(value)
        end
      end

      it 'Incorrect lacpTimer' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink[:lacpTimer] = 'None' }.to raise_error(/Invalid lacp timer/)
      end
    end

    context 'manualLoginRedistributionState' do
      it 'validates manualLoginRedistributionState' do
        uplink = OneviewSDK::Uplink.new(@client)
        values = %w(Distributed Distributing DistributionFailed NotSupported Supported)
        values.each do |value|
          uplink[:manualLoginRedistributionState] = value
          expect(uplink[:manualLoginRedistributionState]).to eq(value)
        end
      end

      it 'Incorrect manualLoginRedistributionState' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink[:manualLoginRedistributionState] = 'None' }.to \
          raise_error(/Invalid manual login redistribution state/)
      end
    end

    context 'networkType' do
      it 'validates networkType' do
        uplink = OneviewSDK::Uplink.new(@client)
        values = %w(Ethernet FibreChannel)
        values.each do |value|
          uplink[:networkType] = value
          expect(uplink[:networkType]).to eq(value)
        end
      end

      it 'Incorrect ethernetNetworkType' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink[:networkType] = 'None' }.to raise_error(/Invalid network type/)
      end
    end

    context 'reachability' do
      it 'validates reachability' do
        uplink = OneviewSDK::Uplink.new(@client)
        values = %w(NotReachable Reachable RedundantlyReachable Unknown)
        values.each do |value|
          uplink[:reachability] = value
          expect(uplink[:reachability]).to eq(value)
        end
      end

      it 'Incorrect reachability' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink[:reachability] = 'None' }.to raise_error(/Invalid reachability/)
      end
    end

    context 'status' do
      it 'validates status' do
        uplink = OneviewSDK::Uplink.new(@client)
        values = %w(OK Disabled Warning Critical Unknown)
        values.each do |value|
          uplink[:status] = value
          expect(uplink[:status]).to eq(value)
        end
      end

      it 'Incorrect status' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink[:status] = 'None' }.to raise_error(/Invalid status/)
      end
    end
  end

  describe 'add elements' do
    context 'networks' do
      it 'Valid' do
        uplink = OneviewSDK::Uplink.new(@client)
        uplink.add_network(uri: '/rest/ethernet-networks')
        uplink.add_fcnetwork(uri: '/rest/fc-networks')
        uplink.add_fcoenetwork(uri: '/rest/fcoe-networks')
        expect(uplink[:networkUris]).to include('/rest/ethernet-networks')
        expect(uplink[:fcNetworkUris]).to include('/rest/fc-networks')
        expect(uplink[:fcoeNetworkUris]).to include('/rest/fcoe-networks')
      end

      it 'Incorrect' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink.add_network({}) }.to raise_error(/Invalid object/)
        expect { uplink.add_fcnetwork({}) }.to raise_error(/Invalid object/)
        expect { uplink.add_fcoenetwork({}) }.to raise_error(/Invalid object/)
      end
    end

    context 'logical interconnects' do
      it 'Valid' do
        uplink = OneviewSDK::Uplink.new(@client)
        uplink.set_logical_interconnect(uri: '/rest/logical-interconnects')
        expect(uplink[:logicalInterconnectUri]).to eq('/rest/logical-interconnects')
      end

      it 'Incorrect' do
        uplink = OneviewSDK::Uplink.new(@client)
        expect { uplink.set_logical_interconnect({}) }.to raise_error(/Invalid object/)
      end
    end
  end

end
