require 'spec_helper'

extra_klass1 = OneviewSDK::API500::C7000::EthernetNetwork
extra_klass2 = OneviewSDK::API500::C7000::FCNetwork
extra_klass3 = OneviewSDK::API500::C7000::FCoENetwork
RSpec.describe OneviewSDK::API500::C7000::LogicalInterconnect do
  include_context 'shared context'

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::API500::C7000::LogicalInterconnect.from_file(@client_500, fixture_path) }

  it 'inherits from OneviewSDK::API300::C7000::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API300::C7000::LogicalInterconnect
  end

  describe '#list_vlan_networks' do
    it 'lists internal networks' do
      item = log_int
      response = {
        'members' => [
          { 'generalNetworkUri' => 'ethernet-network' },
          { 'generalNetworkUri' => 'fc-network' },
          { 'generalNetworkUri' => 'fcoe-network' }
        ]
      }

      allow_any_instance_of(extra_klass1).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(extra_klass2).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(extra_klass3).to receive(:retrieve!).and_return(true)
      expect(@client_500).to receive(:rest_get).with("#{item['uri']}/internalVlans", {}).and_return(true)
      expect(@client_500).to receive(:response_handler).and_return(response)
      result = item.list_vlan_networks
      expect(result).to_not be_empty
      expect(result[0]).to be_instance_of(extra_klass1)
      expect(result[1]).to be_instance_of(extra_klass2)
      expect(result[2]).to be_instance_of(extra_klass3)
      expect(result[0]['uri']).to eq('ethernet-network')
      expect(result[1]['uri']).to eq('fc-network')
      expect(result[2]['uri']).to eq('fcoe-network')
    end
  end
end
