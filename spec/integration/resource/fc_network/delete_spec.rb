require 'spec_helper'

RSpec.describe OneviewSDK::FCNetwork, integration: true, type: DELETE, sequence: 12 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::FCNetwork.new($client, name: FC_NET_NAME)
      item.retrieve!
      item.delete
    end
  end
end
