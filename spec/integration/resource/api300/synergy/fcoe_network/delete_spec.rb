require 'spec_helper'

klass = OneviewSDK::API300::Synergy::FCoENetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'FCoENetworkDeleteExample', 'integration api300 context' do
    let(:current_client) { $client_300_synergy }
  end
end
