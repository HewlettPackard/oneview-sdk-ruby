require 'spec_helper'

RSpec.describe OneviewSDK::FCNetwork, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'updates the network name' do
      item = OneviewSDK::FCNetwork.new($client, name: FC_NET_NAME)
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
