require 'spec_helper'

klass = OneviewSDK::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'LogicalSwitchUpdateExample', 'integration context'
end
