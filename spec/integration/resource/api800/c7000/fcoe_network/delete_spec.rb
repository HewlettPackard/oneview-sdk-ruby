require 'spec_helper'

klass = OneviewSDK::API600::C7000::FCoENetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'FCoENetworkDeleteExample', 'integration api600 context' do
    let(:current_client) { $client_600 }
  end
end
