require 'spec_helper'

klass = OneviewSDK::FCNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::FCNetwork.new($client, name: FC_NET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end
end
