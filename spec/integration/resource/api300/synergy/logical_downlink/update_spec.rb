require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LogicalDownlink, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'LogicalDownlinkUpdateExample', 'integration api300 context'
end
