require 'spec_helper'

klass = OneviewSDK::API800::C7000::HypervisorClusterProfile
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'HypervisorClusterProfileDeleteExample', 'integration api800 context' do
    let(:current_client) { $client_800 }
  end
end
