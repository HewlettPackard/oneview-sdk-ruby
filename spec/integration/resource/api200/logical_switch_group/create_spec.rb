require 'spec_helper'

klass = OneviewSDK::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'LogicalSwitchGroupCreateExample', 'integration context'
end
