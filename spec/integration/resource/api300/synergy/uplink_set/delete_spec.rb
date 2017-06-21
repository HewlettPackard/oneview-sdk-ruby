require 'spec_helper'

klass = OneviewSDK::API300::Synergy::UplinkSet
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300_synergy }
  include_examples 'UplinkSetDeleteExample', 'integration api300 context'
end
