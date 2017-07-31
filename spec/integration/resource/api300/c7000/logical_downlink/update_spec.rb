require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::LogicalDownlink, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'LogicalDownlinkUpdateExample', 'integration api300 context'
end
