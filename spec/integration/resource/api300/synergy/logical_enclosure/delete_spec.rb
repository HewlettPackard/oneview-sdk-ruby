require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalEnclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300_synergy }
  include_examples 'LogicalEnclosureDeleteExample', 'integration api300 context', 'Synergy'
end
