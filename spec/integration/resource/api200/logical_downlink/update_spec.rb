require 'spec_helper'

RSpec.describe OneviewSDK::LogicalDownlink, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'LogicalDownlinkUpdateExample', 'integration context'
end
