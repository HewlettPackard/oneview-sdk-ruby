require 'spec_helper'

klass = OneviewSDK::API800::Synergy::HypervisorManager
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'HypervisorManagerDeleteExample', 'integration api800 context' do
    let(:current_client) { $client_800 }
  end
end
