require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::FCNetwork, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it 'updates the network name' do
      item = OneviewSDK::API300::Thunderbird::FCNetwork.new($client_300_thunderbird, name: FC_NET_NAME)
      item.retrieve!
      item.update(name: FC_NET_NAME_UPDATED)
      item.refresh
      expect(item[:name]).to eq(FC_NET_NAME_UPDATED)
      item.update(name: FC_NET_NAME) # Put it back to normal
      item.refresh
      expect(item[:name]).to eq(FC_NET_NAME)
    end
  end
end
