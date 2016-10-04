require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  include_context 'integration context'

  describe '#get_without_ethernet' do
    it 'instance' do
      item = OneviewSDK::API300::C7000::NetworkSet.new($client, name: NETWORK_SET3_NAME)
      item.retrieve!
      item_without_networks = item.get_without_ethernet
      expect(item_without_networks['networkUris']).to eq([])
    end

    it 'class' do
      OneviewSDK::API300::C7000::NetworkSet.get_without_ethernet($client)['members'].each do |network_set|
        expect(network_set['networkUris']).to eq([])
      end
    end
  end

end
