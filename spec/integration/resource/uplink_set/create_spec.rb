require 'spec_helper'

klass = OneviewSDK::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  let(:uplink_data) do
    {
      nativeNetworkUri: nil,
      reachability: 'Reachable',
      manualLoginRedistributionState: 'NotSupported',
      connectionMode: 'Auto',
      lacpTimer: 'Short',
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged',
      description: nil,
      name: UPLINK_SET3_NAME
    }
  end

  describe '#create' do
    before :each do
      @log_int = OneviewSDK::LogicalInterconnect.new($client, name: LOG_INT_NAME)
      @log_int.retrieve!
    end

    it 'can create the uplink and attach to a Logical Interconnect' do
      item = OneviewSDK::UplinkSet.new($client, uplink_data)
      item[:logicalInterconnectUri] = @log_int[:uri]
      expect { item.create }.not_to raise_error
      expect(item[:uri]).not_to be_empty
    end
  end
end
