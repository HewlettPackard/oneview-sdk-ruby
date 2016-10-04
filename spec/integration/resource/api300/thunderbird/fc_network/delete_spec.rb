require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::FCNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::API300::Thunderbird::FCNetwork.new($client, name: FC_NET_NAME)
      item.retrieve!
      item.delete
    end
  end
end
