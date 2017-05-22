require 'spec_helper'

klass = OneviewSDK::API500::Synergy::SASLogicalInterconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500_synergy }
  include_examples 'SASLogicalInterconnectDeleteExample', 'integration api500 context'
end
