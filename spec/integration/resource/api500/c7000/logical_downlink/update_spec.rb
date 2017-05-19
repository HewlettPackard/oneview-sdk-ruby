require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::LogicalDownlink, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'LogicalDownlinkUpdateExample', 'integration api500 context'
end
