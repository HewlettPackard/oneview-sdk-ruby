require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::FCoENetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::API300::Thunderbird::FCoENetwork.new($client_300, name: FCOE_NET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end
end
