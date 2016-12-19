require 'spec_helper'

klass = OneviewSDK::FCoENetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::FCoENetwork.new($client, name: FCOE_NET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end
end
