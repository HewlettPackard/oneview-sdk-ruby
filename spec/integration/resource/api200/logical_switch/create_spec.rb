require 'spec_helper'

klass = OneviewSDK::LogicalSwitch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:logical_switch_group_class) { OneviewSDK::LogicalSwitchGroup }
  include_examples 'LogicalSwitchCreateExample', 'integration context'
end
