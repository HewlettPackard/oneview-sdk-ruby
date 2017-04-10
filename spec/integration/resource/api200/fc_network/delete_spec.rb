require 'spec_helper'

klass = OneviewSDK::FCNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'FCNetworkDeleteExample', 'integration context' do
    let(:current_client) { $client }
  end
end
