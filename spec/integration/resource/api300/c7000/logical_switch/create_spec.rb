require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:logical_switch_group_class) { OneviewSDK::API300::C7000::LogicalSwitchGroup }
  include_examples 'LogicalSwitchCreateExample', 'integration api300 context'
end
