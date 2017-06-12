require 'spec_helper'

klass = OneviewSDK::API500::Synergy::InternalLinkSet
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'InternalLinkSetDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500 }
  end
end
