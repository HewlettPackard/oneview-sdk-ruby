require 'spec_helper'

klass = OneviewSDK::FCoENetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'FCoENetworkDeleteExample', 'integration context' do
    let(:current_client) { $client }
  end
end
