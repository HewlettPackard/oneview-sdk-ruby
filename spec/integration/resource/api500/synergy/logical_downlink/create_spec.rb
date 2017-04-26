require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalDownlink
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  include_examples 'LogicalDownlinkCreateExample', 'integration api500 context', true
end
