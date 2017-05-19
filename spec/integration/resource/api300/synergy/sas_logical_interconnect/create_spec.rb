require 'spec_helper'

klass = OneviewSDK::API300::Synergy::SASLogicalInterconnect
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  include_examples 'SASLogicalInterconnectCreateExample', 'integration api300 context'
end
