require 'spec_helper'

klass = OneviewSDK::API300::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:uplink_data) do
    {
      nativeNetworkUri: nil,
      reachability: 'NotReachable',
      manualLoginRedistributionState: 'Supported',
      connectionMode: 'Auto',
      lacpTimer: 'Short',
      networkType: 'FibreChannel',
      ethernetNetworkType: 'NotApplicable',
      description: nil,
      name: UPLINK_SET3_NAME
    }
  end

  let(:log_int) { OneviewSDK::API300::Synergy::LogicalInterconnect.get_all($client_300_synergy).first }

  describe '#create' do
    it 'can create the uplink and attach to a Logical Interconnect' do
      item = klass.new($client_300_synergy, uplink_data)
      item[:logicalInterconnectUri] = log_int[:uri]
      expect { item.create }.not_to raise_error
      expect(item[:uri]).to be
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#get_unassigned_ports' do
    it 'should return a hash with the unassigned uplink set ports' do
      uplink = klass.new($client_300_synergy, name: UPLINK_SET3_NAME)
      expect(uplink.retrieve!).to eq(true)
      ports = uplink.get_unassigned_ports
      expect(ports.class).to eq(Hash)
      expect(ports['members']).not_to be_empty
    end
  end

  describe '::get_schema' do
    it 'should return the JSON schema' do
      schema = klass.get_schema($client_300_synergy)
      expect(schema).to be
      expect(schema.class).to eq(Hash)
    end
  end
end
