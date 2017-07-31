require 'spec_helper'

klass = OneviewSDK::EthernetNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'EthernetNetworkDeleteExample', 'integration context' do
    let(:current_client) { $client }
  end
end
