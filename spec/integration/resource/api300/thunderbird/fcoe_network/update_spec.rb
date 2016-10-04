require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'update OneViewSDK Test FCoE Network name' do
      item = OneviewSDK::FCoENetwork.new($client, name: FCOE_NET_NAME)
      item.retrieve!
      item.update(name: FCOE_NET_NAME_UPDATED)
      item.refresh
      expect(item[:name]).to eq(FCOE_NET_NAME_UPDATED)
      item.update(name: FCOE_NET_NAME) # Put it back to normal
      item.refresh
      expect(item[:name]).to eq(FCOE_NET_NAME)
    end
  end
end
