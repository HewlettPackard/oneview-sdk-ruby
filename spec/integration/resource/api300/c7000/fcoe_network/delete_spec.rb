require 'spec_helper'

klass = OneviewSDK::API300::C7000::FCoENetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'FCoENetworkDeleteExample', 'integration api300 context' do
    let(:current_client) { $client_300 }
  end
end
