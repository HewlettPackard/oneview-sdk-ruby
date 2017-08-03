require 'spec_helper'

klass = OneviewSDK::API500::Synergy::EthernetNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'EthernetNetworkDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
  end
end
